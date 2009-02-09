From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] Validate extent details only when read from the disk
Date: Mon, 09 Feb 2009 11:31:46 +0100
Message-ID: <49900612.3020609@ph.tum.de>
References: <20090207173239.GA25942@skywalker> <1234036882-30656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1234036882-30656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:44616 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbZBIKbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 05:31:48 -0500
In-Reply-To: <1234036882-30656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Make sure we validate extent details only when read from the disk.
>
> @@ -602,15 +607,13 @@ struct ext4_ext_path *
>  ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>  					struct ext4_ext_path *path)
>  {
> +	int need_to_validate = 0;
>  	struct ext4_extent_header *eh;
>  	struct buffer_head *bh;
>  	short int depth, i, ppos = 0, alloc = 0;
>  
>  	eh = ext_inode_hdr(inode);
>  	depth = ext_depth(inode);
> -	if (ext4_ext_check(inode, eh, depth))
> -		return ERR_PTR(-EIO);
> -

This check needs to stay in.

Kind regards,

Thiemo

-- 
+-----------------------------------+--------------------------+
| Dipl.-Phys. Thiemo Nagel          |                          |
| Technische Universitaet Muenchen  | Room    PH1 3276         |
| Physik-Department E18             |                          |
| James-Franck-Strasse              | Phone  +49 89 289-12379  |
| D-85747 Garching                  | Fax    +49 89 289-12570  |
+-----------------------------------+--------------------------+
