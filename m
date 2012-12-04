From: Tao Ma <tm@tao.ma>
Subject: Re: next: ext4 build failure
Date: Tue, 04 Dec 2012 21:42:12 +0800
Message-ID: <50BDFDB4.30002@tao.ma>
References: <50BDC25C.5020509@suse.cz> <20121204132701.GA29083@thunk.org> <50BDFD40.1020202@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>,
	boyu.mt@taobao.com, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41621 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751839Ab2LDNmU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:42:20 -0500
In-Reply-To: <50BDFD40.1020202@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/04/2012 09:40 PM, Tao Ma wrote:
> Hi Ted,
> On 12/04/2012 09:27 PM, Theodore Ts'o wrote:
>> On Tue, Dec 04, 2012 at 10:29:00AM +0100, Jiri Slaby wrote:
>>> Hi,
>>>
>>> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
>>> Author: Tao Ma <boyu.mt@taobao.com>
>>> Date:   Sun Dec 2 20:30:52 2012 -0500
>>>
>>>     ext4: let fallocate handle inline data correctly
>>>
>>> added
>>>
>>> static int int ext4_convert_inline_data(struct inode *inode)
>>>
>>>        ^^^^^^^
>>>
>>> when EXT4_FS_XATTR is unset.
>>>
>>> Care to fix that?
>>
>> Oops.  Thanks for catching this!!!
> Please push the patch with the subject "[PATCH] ext4: Fix inline data
> build warning found by kernel build testing." and these error should go
> away. And also Dan's smatch has found another issue and I have sent out
> the patch with subject "[PATCH] ext4: Fix inline data build warning
> found by kernel build testing.".
sorry, I hit the send button too fast. The subject for the 2nd patch is
"[PATCH] ext4: Fix a build warning in __ext4_journalled_writepage."
Sorry for all the trouble.

Thanks
Tao

