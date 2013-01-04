From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] fs/ext*,f2fs,jffs2,reiserfs: give comments for aclsize
 and count calculation
Date: Fri, 04 Jan 2013 09:45:53 +0800
Message-ID: <50E63451.6000208@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:48002 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3ADBo6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jan 2013 20:44:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



------- Original Message -------
From: Jan Kara <jack@suse.cz>
To: Chen Gang <gang.chen@asianux.com>
Cc: jack@suse.cz; akpm@linux-foundation.org;adilger.kernel@dilger.ca; Theodore Tso <tytso@mit.edu>;jaegeuk.kim@samsung.com; dwmw2@infradead.org;torvalds@linux-foundation.org; linux-ext4@vger.kernel.org;linux-f2fs-devel@lists.sourceforge.net;linux-mtd@lists.infradead.org; reiserfs-devel@vger.kernel.org
Sent: Mon, 31 Dec 2012 16:45:59 +0100
Subject: Re: [PATCH] fs/ext*,f2fs,jffs2,reiserfs: give comments for aclsize and count calculation

>   I agree that defining a constant for this makes sence. Just please be
> more verbose with the comment. This is hardly readable for anyone not
> knowing what's going on in advance. Also braces around 4 are superfluous.
> Add something like the comment below before posix_acl_valid():
> 

  thank for your suggestions.

> /*
>  * posix_acl_valid() makes sure ACL format is the following:
>  * ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER
>  *
>  * [1] Where * is the regexp sense of "0 or more times"
>  * [2] If ACL_USER or ACL_GROUP is present, then ACL_MASK must be present.
>  */
> 
> Then add comment before definition of ACL_MAX_SHORT_ENTRY:
> /*
>  * posix_acl_valid() makes sure that if there are <= 4 ACL entries, then
>  * all of them are short. Otherwise exactly 4 entries are short ones and
>  * other have full length. See comment before that function for exact ACL
>  * format.
>  */

  I will send patch v2 which include the contents which you provide.

    and also add Signed-of-by Jan Kara <jack@suse.cz>

  thanks.


