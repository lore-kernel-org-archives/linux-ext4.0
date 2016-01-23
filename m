From: Jeff Merkey <linux.mdb@gmail.com>
Subject: Re: [BUG REPORT] NULL pointer dereference in jdb2_journal_grab_journal_head
 (RDI)
Date: Sat, 23 Jan 2016 09:54:21 -0700
Message-ID: <CAO6TR8VRZoPuNxHPawa2Vva1jmY4Z+hBPBRtf6tujJbNigEe_A@mail.gmail.com>
References: <CAO6TR8Vhxjp-nX-wPXeBLOPmsHcb7_3y2uxk7x_V19o8hTZG0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34541 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbcAWQyW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Jan 2016 11:54:22 -0500
In-Reply-To: <CAO6TR8Vhxjp-nX-wPXeBLOPmsHcb7_3y2uxk7x_V19o8hTZG0g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/23/16, Jeff Merkey <linux.mdb@gmail.com> wrote:
> If I leave the system in the debugger console overnight with all the
> processors suspended for about 8 hours, then type go, the following
> bug shows up during file I/O.  This particular bug showed up while
> using git to update some branches.
>
> I have only seen this bug once and I attempted to reproduce it to get
> a trace dump but have not been able to trigger it again.  The NULL
> pointer is RDI set to NULL while trying to obtain a lock.
>
> (2)> .z grab_journal
> ffffffffa00bb740 t jbd2_journal_grab_journal_head [jbd2]
> (2)> u ffffffffa00bb740
> jbd2|jbd2_journal_grab_journal_head:
> 0xffffffffa00bb740 0F1F440000      nop    DWORD PTR [rax+rax]=0x0
> 0xffffffffa00bb745 55              push   rbp
> 0xffffffffa00bb746 4889E5          mov    rbp,rsp
> <<<<<<<<<<<<   Crashes here with RDI set to NULL
> 0xffffffffa00bb749 F00FBA2F18      lock bts DWORD PTR [rdi]=0x0,0x18
> <<<<<<<<<<<<
> 0xffffffffa00bb74e 7219            jb
> jbd2_journal_grab_journal_head+0x29 (0xffffffffa00bb769) (down)
> 0xffffffffa00bb750 488B07          mov    rax,QWORD PTR [rdi]=0x0
> 0xffffffffa00bb753 A900000200      test   eax,0x20000
> 0xffffffffa00bb758 741D            je
> jbd2_journal_grab_journal_head+0x37 (0xffffffffa00bb777) (down)
> 0xffffffffa00bb75a 488B4740        mov    rax,QWORD PTR [rdi+64]=0x0
> 0xffffffffa00bb75e 83400801        add    DWORD PTR [rax+8]=0x0,0x1
> 0xffffffffa00bb762 F0806703FE      lock and BYTE PTR [rdi+3]=0x00,0xfe
> 0xffffffffa00bb767 5D              pop    rbp
> 0xffffffffa00bb768 C3              ret
> 0xffffffffa00bb769 F390            pause
> 0xffffffffa00bb76b 488B07          mov    rax,QWORD PTR [rdi]=0x0
> 0xffffffffa00bb76e A900000001      test   eax,0x1000000
> 0xffffffffa00bb773 75F4            jne
> jbd2_journal_grab_journal_head+0x29 (0xffffffffa00bb769) (up)
> 0xffffffffa00bb775 EBD2            jmp
> jbd2_journal_grab_journal_head+0x9 (0xffffffffa00bb749) (up)
> 0xffffffffa00bb777 31C0            xor    eax,eax
>
> The backtrace showed this function being called from the swapper
> thread when the crash occurred.   It's damn hard to reproduce.  If I
> see it again, I'll get you a better trace.
>
> Jeff
>

Here is an objdump of the code in question.


0000000000005540 <jbd2_journal_grab_journal_head>:
/*
 * Grab a ref against this buffer_head's journal_head.  If it ended up not
 * having a journal_head, return NULL
 */
struct journal_head *jbd2_journal_grab_journal_head(struct buffer_head *bh)
{
    5540:	e8 00 00 00 00       	callq  5545 <jbd2_journal_grab_journal_head+0x5>
    5545:	55                   	push   %rbp
    5546:	48 89 e5             	mov    %rsp,%rbp
 * This operation is atomic and cannot be reordered.
 * It also implies a memory barrier.
 */
static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
{
	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", "c");

    5549:	f0 0f ba 2f 18       	lock btsl $0x18,(%rdi) << crashes here RDI=NULL

    554e:	72 19                	jb     5569
<jbd2_journal_grab_journal_head+0x29>
}

static __always_inline int constant_test_bit(long nr, const volatile
unsigned long *addr)
{
	return ((1UL << (nr & (BITS_PER_LONG-1))) &
		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
    5550:	48 8b 07             	mov    (%rdi),%rax
	struct journal_head *jh = NULL;

	jbd_lock_bh_journal_head(bh);
	if (buffer_jbd(bh)) {
    5553:	a9 00 00 02 00       	test   $0x20000,%eax
    5558:	74 1d                	je     5577
<jbd2_journal_grab_journal_head+0x37>

/*
 * Grab a ref against this buffer_head's journal_head.  If it ended up not
 * having a journal_head, return NULL
 */
struct journal_head *jbd2_journal_grab_journal_head(struct buffer_head *bh)
    555a:	48 8b 47 40          	mov    0x40(%rdi),%rax
	struct journal_head *jh = NULL;

	jbd_lock_bh_journal_head(bh);
	if (buffer_jbd(bh)) {
		jh = bh2jh(bh);
		jh->b_jcount++;
    555e:	83 40 08 01          	addl   $0x1,0x8(%rax)
 */
static __always_inline void
clear_bit(long nr, volatile unsigned long *addr)
{
	if (IS_IMMEDIATE(nr)) {
		asm volatile(LOCK_PREFIX "andb %1,%0"
    5562:	f0 80 67 03 fe       	lock andb $0xfe,0x3(%rdi)
	}
	jbd_unlock_bh_journal_head(bh);
	return jh;
}
    5567:	5d                   	pop    %rbp
    5568:	c3                   	retq
    5569:	f3 90                	pause
}

static __always_inline int constant_test_bit(long nr, const volatile
unsigned long *addr)
{
	return ((1UL << (nr & (BITS_PER_LONG-1))) &
		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
    556b:	48 8b 07             	mov    (%rdi),%rax
    556e:	a9 00 00 00 01       	test   $0x1000000,%eax
    5573:	75 f4                	jne    5569
<jbd2_journal_grab_journal_head+0x29>
		preempt_disable();
    5575:	eb d2                	jmp    5549 <jbd2_journal_grab_journal_head+0x9>
 * Grab a ref against this buffer_head's journal_head.  If it ended up not
 * having a journal_head, return NULL
 */
struct journal_head *jbd2_journal_grab_journal_head(struct buffer_head *bh)
{
	struct journal_head *jh = NULL;
    5577:	31 c0                	xor    %eax,%eax
    5579:	eb e7                	jmp    5562
<jbd2_journal_grab_journal_head+0x22>
    557b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000005580 <jbd2_journal_put_journal_head>:
/*
 * Drop a reference on the passed journal_head.  If it fell to zero then
 * release the journal_head from the buffer_head.
 */
void jbd2_journal_put_journal_head(struct journal_head *jh)
{
    5580:	e8 00 00 00 00       	callq  5585 <jbd2_journal_put_journal_head+0x5>
    5585:	55                   	push   %rbp
    5586:	48 89 e5             	mov    %rsp,%rbp
    5589:	41 54                	push   %r12
    558b:	53                   	push   %rbx

/*
 * Drop a reference on the passed journal_head.  If it fell to zero then
 * release the journal_head from the buffer_head.
 */
void jbd2_journal_put_journal_head(struct journal_head *jh)
    558c:	48 8b 1f             	mov    (%rdi),%rbx
 * This operation is atomic and cannot be reordered.
 * It also implies a memory barrier.
 */
static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
{
	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", "c");
    558f:	f0 0f ba 2b 18       	lock btsl $0x18,(%rbx)
    5594:	72 1f                	jb     55b5 <jbd2_journal_put_journal_head+0x35>
{
	struct buffer_head *bh = jh2bh(jh);

	jbd_lock_bh_journal_head(bh);
	J_ASSERT_JH(jh, jh->b_jcount > 0);
    5596:	8b 47 08             	mov    0x8(%rdi),%eax
    5599:	85 c0                	test   %eax,%eax
    559b:	0f 8e be 00 00 00    	jle    565f <jbd2_journal_put_journal_head+0xdf>
	--jh->b_jcount;
    55a1:	83 e8 01             	sub    $0x1,%eax
	if (!jh->b_jcount) {
    55a4:	85 c0                	test   %eax,%eax
{
	struct buffer_head *bh = jh2bh(jh);

	jbd_lock_bh_journal_head(bh);
	J_ASSERT_JH(jh, jh->b_jcount > 0);
	--jh->b_jcount;
    55a6:	89 47 08             	mov    %eax,0x8(%rdi)
	if (!jh->b_jcount) {
