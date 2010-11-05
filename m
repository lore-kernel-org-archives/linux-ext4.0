From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 37/49] fs/ext4: Use vzalloc
Date: Fri, 5 Nov 2010 01:02:13 -0600
Message-ID: <F35C793E-7CBA-4631-8928-C34D5B39F148@dilger.ca>
References: <alpine.DEB.2.00.1011031108260.11625@router.home> <960a7efc569f61a50346257835ce5f457a0d4c99.1288925425.git.joe@perches.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jiri Kosina <trivial@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:13516 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0KEHCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Nov 2010 03:02:15 -0400
In-Reply-To: <960a7efc569f61a50346257835ce5f457a0d4c99.1288925425.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-04, at 21:08, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> @@ -1909,9 +1909,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
> 	size = flex_group_count * sizeof(struct flex_groups);
> 	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
> 	if (sbi->s_flex_groups == NULL) {
> -		sbi->s_flex_groups = vmalloc(size);
> -		if (sbi->s_flex_groups)
> -			memset(sbi->s_flex_groups, 0, size);
> +		sbi->s_flex_groups = vzalloc(size);
> 	}
> 	if (sbi->s_flex_groups == NULL) {
> 		ext4_msg(sb, KERN_ERR, "not enough memory for "

You may as well move the second s_flex_groups == NULL check inside the first one:

	if (sbi->s_flex_groups == NULL) {
		sbi->s_flex_groups = vzalloc(size);
		if (sbi->s_flex_groups == NULL) {
			ext4_msg(sb, KERN_ERR, "not enough memory for "
				 "%u flex groups", flex_group_count);
			goto failed;
		}
	}

Cheers, Andreas





