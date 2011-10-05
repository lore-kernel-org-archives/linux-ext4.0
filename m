From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: RE: [PATCH] ext3/xattr_seciruty.c: local functions should be static
Date: Wed, 5 Oct 2011 12:27:06 -0500
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DCFE896@AUSP01VMBX24.collaborationhost.net>
References: <201109231507.09998.hartleys@visionengravers.com>
 <20111004233746.GC21205@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail160.messagelabs.com ([216.82.253.99]:58377 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934481Ab1JER1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Oct 2011 13:27:18 -0400
In-Reply-To: <20111004233746.GC21205@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, October 04, 2011 4:38 PM, Jan Kara wrote:
> On Fri 23-09-11 15:07:09, H Hartley Sweeten wrote:
>> Quiets the sparse noise:
>> 
>> warning: symbol 'ext3_initxattrs' was not declared. Should it be static?
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>  Here applies the same comment as to the ext2 patch - not in current
> Linus' kernel AFAICS.

These are in linux-next due to:

commit 9d8f13ba3f4833219e50767b022b82cd0da930eb
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Mon Jun 6 15:29:25 2011 -0400

    security: new security_inode_init_security API adds function callback

I can repost these after this commit hits Linus' kernel if necessary.

Thanks,
Hartley