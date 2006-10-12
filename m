From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] [PATCH] Documentation/filesystems/ext4.txt
Date: Thu, 12 Oct 2006 16:18:44 +0200
Message-ID: <452E4EC4.6030607@bull.net>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>	 <20061005173933.f54555fb.akpm@osdl.org>	 <20061009232927.77b667c2.akpm@osdl.org> <20061010075402.GA23992@in.ibm.com>	 <20061010011434.e8e2f76b.akpm@osdl.org> <1160510555.28923.15.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@osdl.org>, suparna@in.ibm.com,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41600 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932087AbWJLOUJ
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Oct 2006 10:20:09 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1160510555.28923.15.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dave Kleikamp wrote:

> +2.2 Candidate features for future inclusion
> +
> +There are several under discussion, whether they all make it in is
> +partly a function of how much time everyone has to work on them:
> +
> +* improved file allocation (multi-block alloc, delayed alloc; basica=
lly done)
> +* fix 32000 subdirectory limit (patch exists, needs some e2fsck work=
)
> +* nsec timestamps for mtime, atime, ctime, create time (patch exists=
,
> +  needs some e2fsck work)
> +* inode version field on disk (NFSv4, Lustre; prototype exists)
> +* reduced mke2fs/e2fsck time via uninitialized groups (prototype exi=
sts)
> +* journal checksumming for robustness, performance (prototype exists=
)
> +* persistent file preallocation (e.g for streaming media, databases)

Could you add "support of larger block group size" ?
Currently, a prototype exists, but we still have tests to do.

Thanks,
   Val=E9rie
-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
