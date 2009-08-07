From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 13930] New: non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 07 Aug 2009 14:08:40 -0500
Message-ID: <4A7C7BB8.2060904@redhat.com>
References: <bug-13930-13602@http.bugzilla.kernel.org/> <20090807185853.GK3340@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: zelogik+bugzilla@gmail.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbZHGTIr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2009 15:08:47 -0400
In-Reply-To: <20090807185853.GK3340@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Aug 07, 2009  09:58 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>> Normally ext4 is a perfect non-contifuous FS ... so why when I make an:
>>
>> sudo e2fsck -v -f -p /dev/sdc1
>>
>>    15953 inodes used (0.03%)
>>    10361 non-contiguous files (64.9%)
>>
>> We have 64.9% of non-contiguous files on a ext4 fs, 
>>
>> Files have been transfered from a cifs mount (useful ?) and files size are
>> [2-10]|[600-800]MB
> 
> Note that the largest single extent in ext4 is 128MB, so it is perfectly
> normal to have fragmented files if they are 600MB in size.  Maybe we should
> change the e2fsck stats to not consider a file fragmented if it fills the
> whole block group (less any metadata therein)?

Ah that crossed my mind, but since so many other e2fsprogs tools
coalesce adjacent extents and report "1" I figured e2fsck was too
(though I didn't look...)

-Eric
