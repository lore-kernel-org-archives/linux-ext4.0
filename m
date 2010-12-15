From: Edward Shishkin <edward@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix type-punning warnings
Date: Wed, 15 Dec 2010 19:53:33 +0100
Message-ID: <4D090EAD.5000203@redhat.com>
References: <4D07BEB1.8030406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab0LOSyb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Dec 2010 13:54:31 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBFIsVA7025925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 15 Dec 2010 13:54:31 -0500
In-Reply-To: <4D07BEB1.8030406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Flags used during RHEL/Fedora builds lead to a couple type-punning
> warnings:
>
>   recovery.c: In function 'do_one_pass':
>   recovery.c:539: warning: dereferencing type-punned pointer will break strict-aliasing rules
>   ./csum.c: In function 'print_csum':
>   ./csum.c:170: warning: dereferencing type-punned pointer will break strict-aliasing rules
>
> The two changes below fix this up.
>
> Note that the csum test binary output changes slightly, but this does
> not break any tests.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>   

Acked-by: Edward Shishkin <edward@redhat.com>


> ---
>
> diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
> index 8e40575..cac9294 100644
> --- a/e2fsck/recovery.c
> +++ b/e2fsck/recovery.c
> @@ -536,8 +536,10 @@ static int do_one_pass(journal_t *journal,
>  					memcpy(nbh->b_data, obh->b_data,
>  							journal->j_blocksize);
>  					if (flags & JFS_FLAG_ESCAPE) {
> -						*((__be32 *)nbh->b_data) =
> -						cpu_to_be32(JFS_MAGIC_NUMBER);
> +						journal_header_t *header;
> +
> +						header = (journal_header_t *) &nbh->b_data[0];
> +						header->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
>  					}
>  
>  					BUFFER_TRACE(nbh, "marking dirty");
> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> index a71d12c..1024c10 100644
> --- a/lib/ext2fs/Makefile.in
> +++ b/lib/ext2fs/Makefile.in
> @@ -317,7 +317,7 @@ tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(DEPLIBSS) \
>  tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
>  	$(E) "	LD $@"
>  	$(Q) $(CC) -o tst_csum $(srcdir)/csum.c -DDEBUG \
> -		$(ALL_CFLAGS) $(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
> +		$(ALL_CFLAGS) $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(LIBE2P)
>  
>  mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
>  	$(E) "	LD $@"
> diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
> index 58ebd23..2b6b364 100644
> --- a/lib/ext2fs/csum.c
> +++ b/lib/ext2fs/csum.c
> @@ -166,9 +166,9 @@ void print_csum(const char *msg, ext2_filsys fs, dgrp_t group)
>  	crc2 = ext2fs_crc16(crc1, &swabgroup, sizeof(swabgroup));
>  	crc3 = ext2fs_crc16(crc2, desc,
>  			    offsetof(struct ext2_group_desc, bg_checksum));
> -	printf("%s: UUID %016Lx%016Lx(%04x), grp %u(%04x): %04x=%04x\n",
> -	       msg, *(long long *)&sb->s_uuid, *(long long *)&sb->s_uuid[8],
> -	       crc1, group, crc2, crc3, ext2fs_group_desc_csum(fs, group));
> +	printf("%s: UUID %s(%04x), grp %u(%04x): %04x=%04x\n",
> +	       msg, e2p_uuid2str(sb->s_uuid), crc1, group, crc2,crc3,
> +	       ext2fs_group_desc_csum(fs, group));
>  }
>  
>  unsigned char sb_uuid[16] = { 0x4f, 0x25, 0xe8, 0xcf, 0xe7, 0x97, 0x48, 0x23,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
