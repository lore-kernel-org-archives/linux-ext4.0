From: "George Spelvin" <linux@horizon.com>
Subject: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: 21 Sep 2014 05:53:39 -0400
Message-ID: <20140921095339.9074.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:50798 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750903AbaIUJxm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 05:53:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was figuring out which directory hash I wanted on a new file system,
and wasn't really thrilled with any of them.

SipHash beats the current options on 32-bit x86:
* Testing strings up to 4096 bytes:
Test siphash24a: Elapsed = 20.754133
Test siphash24:  Elapsed = 24.751991
Test teahash:    Elapsed = 68.409799
Test md4hash:    Elapsed = 42.375412
* Testing strings up to 8 bytes:
Test siphash24a: Elapsed = 0.001247
Test siphash24:  Elapsed = 0.001181
Test teahash:    Elapsed = 0.001944
Test md4hash:    Elapsed = 0.001421
* Testing strings up to 16 bytes:
Test siphash24a: Elapsed = 0.003101
Test siphash24:  Elapsed = 0.003125
Test teahash:    Elapsed = 0.004847
Test md4hash:    Elapsed = 0.003728
* Testing strings up to 24 bytes:
Test siphash24a: Elapsed = 0.005415
Test siphash24:  Elapsed = 0.005622
Test teahash:    Elapsed = 0.009881
Test md4hash:    Elapsed = 0.006789

And obviously does even better on 64 bits:
* Testing strings up to 4096 bytes:
Test siphash24a: Elapsed = 5.222064
Test siphash24:  Elapsed = 5.200439
Test teahash:    Elapsed = 61.071545
Test md4hash:    Elapsed = 39.958463
* Testing strings up to 8 bytes:
Test siphash24a: Elapsed = 0.000394
Test siphash24:  Elapsed = 0.000320
Test teahash:    Elapsed = 0.001690
Test md4hash:    Elapsed = 0.001216
* Testing strings up to 16 bytes:
Test siphash24a: Elapsed = 0.000920
Test siphash24:  Elapsed = 0.000829
Test teahash:    Elapsed = 0.004279
Test md4hash:    Elapsed = 0.003262
* Testing strings up to 24 bytes:
Test siphash24a: Elapsed = 0.001580
Test siphash24:  Elapsed = 0.001448
Test teahash:    Elapsed = 0.008824
Test md4hash:    Elapsed = 0.005956


This is with the following test code, which started with me testing the
"read word at a time, but don't memory fault" optimization, but I turned
into a cheesy benchmark.

Basically, it offers security similar to teahash with a faster, and better
studied, primitive designed specifically for this application.

I'm thinking of turning this into a patch for ext2utils and fs/ext4.

Could I ask what the general level of interest is?  On a scale of "hell,
no, not more support burden!" to "thank you, I've been meaning to find
time to add that!"

I'm planning on using the "siphash24" code, which is slightly slower than
the more unrolled "siphash24a" code on 32-bit, but about 55% the size:

Function size	32-bit	64-bit
siphash24	1043	381
siphash24a	1955	661

I'm assuming DX_HASH_SIPHASH_2_4=6 would be the right value.


-- 8< --- Current ugly test/benchmark code --- 8< ---
#include <stdint.h>
#include <string.h>

#if 0	/* Linux kernel */

#include <bitops.h>	/* For rol64 */
#include <asm/unaligned.h>

#else /* Emulation */

#include <endian.h>

#define __le64_to_cpu le64toh
#define __get_unaligned_cpu64(p) __le64_to_cpu(*(uint64_t const *)(p))

#define rol64(x,s) ((x) << (s) | (x) >> (64-(s)))

#define __pure __attribute__((pure))

#endif


#define SIP_MIX(a,b,s) ( (a) += (b), (b) = rol64(b, s), (b) ^= (a) )

#define SIP_ROUND(a,b,c,d) \
	( SIP_MIX(a, b, 13), SIP_MIX(c, d, 16), (a) = rol64(a, 32), \
	  SIP_MIX(c, b, 17), SIP_MIX(a, d, 21), (c) = rol64(c, 32) )

#define SIP_MIXIN(a,b,c,d,m) \
	( (d) ^= (m), SIP_ROUND(a,b,c,d), SIP_ROUND(a,b,c,d), (a) ^= (m) )


/*
 * This is the "fast" version.
 * i386:  1955 bytes, 23.789444 seconds
 * x86-64: 661 bytes,  5.203469 seconds
 */
uint64_t __pure
siphash24a(char const *msg, int len, uint32_t const seed[4])
{
	uint64_t a = 0x736f6d6570736575;	/* somepseu */
	uint64_t b = 0x646f72616e646f6d;	/* dorandom */
	uint64_t c = 0x6c7967656e657261;	/* lygenera */
	uint64_t d = 0x7465646279746573;	/* tedbytes */
	uint64_t m;
	unsigned r;

	/* Mix in the 128-bit hash seed */
	if (seed) {
		m = seed[0] | (uint64_t)seed[1] << 32;
		a ^= m; c ^= m;
		m = seed[2] | (uint64_t)seed[3] << 32;
		b ^= m; d ^= m;
	}

	/* Mix in all the complete words, until r < 8 */
	for (r = len; r >= 8; r -= 8, msg += 8) {
		m = __get_unaligned_cpu64(msg);
		SIP_MIXIN(a, b, c, d, m);
	}

	/*
	 * The last partial word is tricky.  We'd like to do one fetch, but
	 * we can't just to a 64-bit fetch and mask, because that
	 * might hit a protection boundary.  Fortunately, we know that
	 * protection boundaries are 64-bit aligned, so we can
	 * consider only three cases:
	 * - The remainder occupies zero words
	 * - The remainder fits into one word
	 * - The remainder straddles two words
	 */
	if (!r) {
		m = 0;
	} else {
		unsigned offset = (unsigned)(unsigned long)msg & 7;

		if (offset + r > 8) {
			m = __get_unaligned_cpu64(msg);
		} else {
			m = __le64_to_cpu(*(uint64_t const *)(msg - offset));
			m >>= 8*offset;
		}
		m &= ((uint64_t)1 << 8*r) - 1;
	}
	/* Padding is one byte of length mod 256 */
	m |= (uint64_t)len << 56;
	SIP_MIXIN(a, b, c, d, m);

	/* Finalization */
	c ^= 0xff;
	SIP_ROUND(a, b, c, d);
	SIP_ROUND(a, b, c, d);
	SIP_ROUND(a, b, c, d);
	SIP_ROUND(a, b, c, d);

	return a ^ b ^ c ^ d;
}

/*
 * A more space-efficient version.
 * i386:  1043 bytes, 28.400234 seconds
 * x86-64: 381 bytes,  5.160729 seconds
 *
 * Hey, same speed or faster; I like that!
 * But 20% slower on 32-bit, sigh.
 */
uint64_t __pure
siphash24(char const *msg, int len, uint32_t const seed[4])
{
	uint64_t a = 0x736f6d6570736575;	/* somepseu */
	uint64_t b = 0x646f72616e646f6d;	/* dorandom */
	uint64_t c = 0x6c7967656e657261;	/* lygenera */
	uint64_t d = 0x7465646279746573;	/* tedbytes */
	uint64_t m = 0;
	unsigned r = (len + 1) / 8 + 2;		/* Number of double-rounds to perform */

	/* Mix in the 128-bit hash seed */
	if (seed) {
		m = seed[2] | (uint64_t)seed[3] << 32;
		b ^= m;
		d ^= m;
		m = seed[0] | (uint64_t)seed[1] << 32;
		/* a ^= m; is done in loop below */
		c ^= m;
	}

	/*
	 * By using the same SIP mixing code for all iterations, we
	 * save space, at the expense of some branch prediction.  But
	 * branch prediction is hard because of variable length anyway.
	 */
	do {
		a ^= m;

		switch (--r) {
		  unsigned bytes;

		  default:	/* Full words */
			d ^= m = __get_unaligned_cpu64(msg);
			msg += 8;
			break;
		  case 2:	/* Final partial word */
			/*
			 * We'd like to do one 64-bit fetch rather than mess
			 * around with bytes, but reading past the end might hit
			 * a protection boundary.  Fortunately, we know that
			 * protection boundaries are aligned, so we can
			 * consider only three cases:
			 * - The remainder occupies zero words
			 * - The remainder fits into one word
			 * - The remainder straddles two words
			 */
			bytes = len & 7;
			
			if (bytes == 0) {
				m = 0;
			} else {
				unsigned offset = (unsigned)(unsigned long)msg & 7;

				if (offset + bytes > 8) {
					m = __get_unaligned_cpu64(msg);
				} else {
					m = __le64_to_cpu(*(uint64_t const *)(msg - offset));
					m >>= 8*offset;
				}
				m &= ((uint64_t)1 << 8*bytes) - 1;
			}
			/* We could use OR or +, but XOR lets the compiler rearrange */
			d ^= m ^= (uint64_t)len << 56;
			break;
		  case 1:
			m = 0;
			c ^= 0xff;	/* Beginning of finalization */
			/*FALLTHROUGH*/
		  case 0:
			break;
		}

		SIP_ROUND(a, b, c, d);
		SIP_ROUND(a, b, c, d);
	} while (r);

	return a ^ b ^ c ^ d;
}

#undef SIP_MIXIN
#undef SIP_ROUND
#undef SIP_MIX

/*
 * Keyed 32-bit hash function using TEA in a Davis-Meyer function
 *   H0 = Key
 *   Hi = E Mi(Hi-1) + Hi-1
 *
 * (see Applied Cryptography, 2nd edition, p448).
 *
 * Jeremy Fitzhardinge <jeremy@zip.com.au> 1998
 *
 * This code is made available under the terms of the GPL
 */
#define DELTA 0x9E3779B9

static void TEA_transform(uint32_t buf[2], uint32_t const in[4])
{
	uint32_t sum = 0;
	uint32_t b0 = buf[0], b1 = buf[1];
	uint32_t a = in[0], b = in[1], c = in[2], d = in[3];
	int n = 16;

	do {
		sum += DELTA;
		b0 += ((b1 << 4)+a) ^ (b1+sum) ^ ((b1 >> 5)+b);
		b1 += ((b0 << 4)+c) ^ (b0+sum) ^ ((b0 >> 5)+d);
	} while (--n);

	buf[0] += b0;
	buf[1] += b1;
}

#undef DELTA

static void str2hashbuf(char const *msg, int len, uint32_t *buf, int num)
{
	uint32_t pad, val;
	int i;
	unsigned char const *ucp = (unsigned char const *)msg;


	pad = (uint32_t)len | (uint32_t)len << 8;
	pad |= pad << 16;

	val = pad;
	if (len > num*4)
		len = num * 4;
	for (i = 0; i < len; i++) {
		val = (val << 8) + ucp[i];
		if (i % 4 == 3) {
			*buf++ = val;
			val = pad;
			num--;
		}
	}
	while (--num >= 0) {
		*buf++ = val;
		val = pad;
	}
}

uint64_t __pure
teahash(char const *msg, int len, uint32_t const seed[4])
{
	static uint32_t const init[4] = {
		0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476 };
	uint32_t buf[2], in[4];

	memcpy(buf, seed ? seed : init, sizeof(buf));

	while (len > 0) {
		str2hashbuf(msg, len, in, 4);
		TEA_transform(buf, in);
		len -= 16;
		msg += 16;
	}
	return (uint64_t)buf[1] << 32 | buf[0];
}

/* F, G and H are basic MD4 functions: selection, majority, parity */
#define F(x, y, z) ((z) ^ ((x) & ((y) ^ (z))))
#define G(x, y, z) (((x) & (y)) + (((x) ^ (y)) & (z)))
#define H(x, y, z) ((x) ^ (y) ^ (z))

/*
 * The generic round function.  The application is so specific that
 * we don't bother protecting all the arguments with parens, as is generally
 * good macro practice, in favor of extra legibility.
 * Rotation is separate from addition to prevent recomputation
 */
#define ROUND(f, a, b, c, d, x, s)	\
	(a += f(b, c, d) + x, a = (a << s) | (a >> (32-s)))
#define K1 0
#define K2 013240474631UL
#define K3 015666365641UL

/*
 * Basic cut-down MD4 transform.  Returns only 32 bits of result.
 */
static void halfMD4Transform (uint32_t buf[4], uint32_t const in[8])
{
	uint32_t a = buf[0], b = buf[1], c = buf[2], d = buf[3];

	/* Round 1 */
	ROUND(F, a, b, c, d, in[0] + K1,  3);
	ROUND(F, d, a, b, c, in[1] + K1,  7);
	ROUND(F, c, d, a, b, in[2] + K1, 11);
	ROUND(F, b, c, d, a, in[3] + K1, 19);
	ROUND(F, a, b, c, d, in[4] + K1,  3);
	ROUND(F, d, a, b, c, in[5] + K1,  7);
	ROUND(F, c, d, a, b, in[6] + K1, 11);
	ROUND(F, b, c, d, a, in[7] + K1, 19);

	/* Round 2 */
	ROUND(G, a, b, c, d, in[1] + K2,  3);
	ROUND(G, d, a, b, c, in[3] + K2,  5);
	ROUND(G, c, d, a, b, in[5] + K2,  9);
	ROUND(G, b, c, d, a, in[7] + K2, 13);
	ROUND(G, a, b, c, d, in[0] + K2,  3);
	ROUND(G, d, a, b, c, in[2] + K2,  5);
	ROUND(G, c, d, a, b, in[4] + K2,  9);
	ROUND(G, b, c, d, a, in[6] + K2, 13);

	/* Round 3 */
	ROUND(H, a, b, c, d, in[3] + K3,  3);
	ROUND(H, d, a, b, c, in[7] + K3,  9);
	ROUND(H, c, d, a, b, in[2] + K3, 11);
	ROUND(H, b, c, d, a, in[6] + K3, 15);
	ROUND(H, a, b, c, d, in[1] + K3,  3);
	ROUND(H, d, a, b, c, in[5] + K3,  9);
	ROUND(H, c, d, a, b, in[0] + K3, 11);
	ROUND(H, b, c, d, a, in[4] + K3, 15);

	buf[0] += a;
	buf[1] += b;
	buf[2] += c;
	buf[3] += d;
}

#undef ROUND
#undef F
#undef G
#undef H
#undef K1
#undef K2
#undef K3

uint64_t __pure
md4hash(char const *msg, int len, uint32_t const seed[4])
{
	static uint32_t const init[4] = {
		0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476 };
	uint32_t buf[4], in[8];

	memcpy(buf, seed ? seed : init, sizeof(buf));

	while (len > 0) {
		str2hashbuf(msg, len, in, 8);
		halfMD4Transform(buf, in);
		len -= 32;
		msg += 32;
	}
	return (uint64_t)buf[2] << 32 | buf[1];
}

#include <string.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/time.h>

#define PAGESIZE 4096

uint64_t time_test(char const *buf, int len, int maxlen, uint64_t f(char const *, int, uint32_t const [4]))
{
	struct timeval tv1, tv2;
	uint64_t sum = 0;
	int i, j;

	if (gettimeofday(&tv1, NULL) < 0) {
		perror("gettimeofday");
		return 0;
	}

	for (i = 1; i < maxlen; i++)
		for (j = 0; j < len - i; j++)
			sum += f(buf+j, i, NULL);

	if (gettimeofday(&tv2, NULL) < 0) {
		perror("gettimeofday");
		return 0;
	}
	tv2.tv_sec -= tv1.tv_sec;
	tv2.tv_usec -= tv1.tv_usec;
	if (tv2.tv_usec < 0) {
		tv2.tv_sec--;
		tv2.tv_usec += 1000000;
	}
	printf("Elapsed = %u.%06u\n", (unsigned)tv2.tv_sec,
		(unsigned)tv2.tv_usec);
	return sum;
}

int
main(void)
{
	char *buf;
	int i, j;

	/* The test vector in the SipHash specification */
	static uint32_t const key[4] = {
		0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c
	};
	static char const message[15] = "\0\1\2\3\4\5\6\7\10\11\12\13\14\15\16";
	uint64_t const hexpected = 0xa129ca6149be45e5;
	uint64_t htest = siphash24(message, sizeof message, key);

	printf("Test hash = %016llx\n"
               "Expected  = %016llx\n", htest, hexpected);
	if (htest != hexpected)
		return 1;

	buf = mmap(NULL, 2*PAGESIZE, PROT_READ|PROT_WRITE,
	           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (buf == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	if (munmap(buf + PAGESIZE, PAGESIZE) < 0) {
		perror("munmap");
		return 1;
	}

	for (i = 0; i < 8; i++) {
		char *p = buf + PAGESIZE - sizeof message - i;
		memcpy (p, message, sizeof message);
		htest = siphash24(p, sizeof message, key);
		printf("Test %-4d = %016llx\n", i, htest);
		if (htest != hexpected)
			return 1;
		
	}

	memset(buf, 'x', PAGESIZE);

	for (i = 0; i < PAGESIZE; i++) {
		uint64_t const h1 = siphash24(buf, i, NULL);

		if ((i & 15) == 15) {
			printf("\rHash(%u) = %016llx", i, h1);
			fflush(stdout);
		}

		for (j = 1; j < PAGESIZE - i; j++) {
			uint64_t const h2 = siphash24(buf+j, i, NULL);

			if (h2 != h1) {
				printf("\nERROR: hash@%u = %016llx\n", j, h2);
				return 1;
			}
		}
	}
	putchar('\n');
	for (i = 0; i < 4; i++) {
		int maxlen = i ? 8 * i : 4096;
		printf("* Testing strings up to %d bytes:\n", maxlen);
		fputs("Test siphash24a: ", stdout);
		time_test(buf, PAGESIZE, maxlen, siphash24a);
		fputs("Test siphash24:  ", stdout);
		time_test(buf, PAGESIZE, maxlen, siphash24);
		fputs("Test teahash:    ", stdout);
		time_test(buf, PAGESIZE, maxlen, teahash);
		fputs("Test md4hash:    ", stdout);
		time_test(buf, PAGESIZE, maxlen, md4hash);
	}

	return 0;
}
