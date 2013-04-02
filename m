From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Wed, 03 Apr 2013 02:05:48 +0400
Message-ID: <87r4isd1vn.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59173 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3DBWFy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2013 18:05:54 -0400
In-Reply-To: <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2 Apr 2013 14:35:29 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> On Tue, 2 Apr 2013 at 13:47, Dmitry Monakhov wrote:
> > So you just do bunch of writes/mmap to fallocated area.
> > The only guess I have is that some bug in extent status tree
> > 
> > Please run test with a patch which was posted here:
> > http://marc.info/?l=linux-kernel&m=136455173926544&w=2
> > This patch enable sanity checks for extent_status tree.
> > Also please try following patch. It voluntary disable es_lookup functionality.
> 
> I tested your patch below (applied to 3.9-rc4) and now the BUG is gone. 
> The machine stays up and the corruption of that torrent file is gone too! 
> 
> Feel free to add my Tested-by: but I don't know if this will be the final 
> solution to this issue, no?
No. This is just a proof that es_cache is a root of cause.
Please drop that patch and collect logs with a kernel which 
has only 0001-enable-ES_AGGRESSIVE_TEST-V2.patch patch applied
This can help us understand what was wrong. From CAI Qian's
logs(http://marc.info/?l=linux-ext4&m=136489690730402&w=2) 
I found that in most cases assertion failed because
ec_cache contains BH_Mapped entries, but extent_tree has not data at all

Also there is another assertion failure where
es_cache {15/1/33490/MAPPED}  != extent_tree {15/1/33579/BH_UNWRITTEN}

> 
> Thanks!
> Christian.
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c> index fe3337a..95d27cd 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -689,6 +689,7 @@ int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
>  	trace_ext4_es_lookup_extent_enter(inode, lblk);
>  	es_debug("lookup extent in block %u\n", lblk);
>  
> +	return 0;
>  	tree = &EXT4_I(inode)->i_es_tree;
>  	read_lock(&EXT4_I(inode)->i_es_lock);
>  
> -- 
> BOFH excuse #414:
> 
> tachyon emissions overloading the system
