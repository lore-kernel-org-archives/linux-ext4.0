From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v1] ext4:Make FIEMAP and delayed allocation play well
 together.
Date: Thu, 24 Feb 2011 16:23:01 -0600
Message-ID: <4D66DA45.5050201@redhat.com>
References: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1BXWXE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 17:23:04 -0500
In-Reply-To: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/24/2011 10:15 AM, Yongqiang Yang wrote:
> 1. lookup dirty pages with specified range in pagecache.
>    If no page is got, then there is no delayed-extent and
>    return with EXT_CONTINUE.
> 2. find the 1st mapped buffer,
> 3. check if the mapped buffer is both in the request range
>    and a delayed buffer. If not, there is no delayed-extent,
>    then return.
> 4. a delayed-extent is found, the extent will be collected.

This does seem to work now; I patched xfstests to do a run
with and without sync, and both pass.

The patches for xfstests are here:

http://oss.sgi.com/pipermail/xfs/2011-February/049525.html
http://oss.sgi.com/pipermail/xfs/2011-February/049527.html

-Eric
