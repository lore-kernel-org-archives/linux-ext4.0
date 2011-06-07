From: Tao Ma <tm@tao.ma>
Subject: Re: big allocation status
Date: Tue, 07 Jun 2011 10:01:54 +0800
Message-ID: <4DED8692.3010302@tao.ma>
References: <4DE83F83.6070302@tao.ma> <20110604033805.GD2614@thunk.org> <20110606230421.GF20818@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37926 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754406Ab1FGCB7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 22:01:59 -0400
In-Reply-To: <20110606230421.GF20818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/07/2011 07:04 AM, Ted Ts'o wrote:
> On Fri, Jun 03, 2011 at 11:38:05PM -0400, Ted Ts'o wrote:
>> On Fri, Jun 03, 2011 at 09:57:23AM +0800, Tao Ma wrote:
>>> Hi Ted,
>>>
>>> Do you have any new branch or patch set that can be used for testing
>>> about big allocation? The latest patch set in the mailist is what you
>>> have sent at the beginning of May. Do you have an updated one? We will
>>> try to test it soon and it would grateful if we are on the same page.
>>
>> There is a patch set available at:
>>
>> git://repo.or.cz/ext4-patch-queue.git
>>
>> The bigalloc patches are after the stable-boundary, and will apply
>> against 3.0-rc1.
> 
> I've updated the bigalloc patch set to fix a number of bugs that I and
> a colleague of mine at Google have found.
> 
> This patch set known have problems with i_blocks getting out of sync
> if delalloc is enabled (particularly with sparse files and truncates),
> and as mentioned before, doesn't work correctly with the punch ioctl.
> These are bugs that we plan to fix before anything gets pushed into
> upstream, of course.
cool, I will base my test on it. Thanks.

Regards,
Tao
