From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Mon, 03 Sep 2012 13:37:48 +0800
Message-ID: <5044422C.9020702@tao.ma>
References: <1340547236-2838-1-git-send-email-tm@tao.ma> <5044208B.2080008@tao.ma> <20120903033905.GC5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:51719 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755096Ab2ICFhx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2012 01:37:53 -0400
In-Reply-To: <20120903033905.GC5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/03/2012 11:39 AM, Theodore Ts'o wrote:
> On Mon, Sep 03, 2012 at 11:14:19AM +0800, Tao Ma wrote:
>> Hi Ted,
>> 	As the corresponding kernel change has been merged, can this patch be
>> merged to the e2fsporgs also?
> 
> Hi Tao,
> 
> I folded your change into the metadata checksum patches before I
> applied them to the next branch (and which is now included in the
> master branch).  So if you use the master/next branch, it should be
> fully in sync with the kernel implementation of metadata checksum.
> This was along with a number of other cleanups that I did to collapse
> related patches before they got fully applied into e2fsprogs.
oh, yeah, I found it after I sent this e-mail.
> 
> I have run xfstests with metadata checksum enabled in the kernel with
> the development branch of e2fsprogs, and it passes, so I'm fairly
> confident they are in sync.
cool. I will use it+inline_data to test the new inline data kernel.
> 
> One of the questions that we should consider in the near future is
> when to cut a e2fsprogs 1.43 release.  Things which we might want to
> consider adding before we cut 1.43 include the changes to fully
> support online resize for 64-bit file systems, and possibly the inline
> data patches, if we are confident in the e2fsprogs changes and that
> the format of inline data is ready to be cast into concrete.
Sure, I have finished the new inline data patches(your suggestion of the
new "..") and run the xfstests on it. Hope the patch set can be sent
this week.

Thanks
Tao
