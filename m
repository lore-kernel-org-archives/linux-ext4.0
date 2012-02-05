From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 5 Feb 2012 12:24:26 -0700
Message-ID: <D9A6076F-154F-41A6-BC18-EC1AF2E73551@dilger.ca>
References: <4F2D8F30.3090802@redhat.com> <201202050933.q159XQpB026380@helium.internal.tigress.co.uk> <4F2EB017.5090006@redhat.com> <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca> <4F2EBB09.6080905@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ron Yorston <rmy@tigress.co.uk>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52800 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2BETY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Feb 2012 14:24:28 -0500
In-Reply-To: <4F2EBB09.6080905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-05, at 10:23 AM, Eric Sandeen wrote:
> On 2/5/12 10:55 AM, Andreas Dilger wrote:
>> On 2012-02-05, at 9:36, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 2/5/12 3:33 AM, Ron Yorston wrote:
>>>> Eric Sandeen wrote:
>>>>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>>>>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>>>> 
>>>>> I'll see if util-linux wants it after it gets beat into shape.
>>>>> (or did a tool like this already exist and I missed it?)
>>> 
>>> Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
>> 
>> I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked,
>> then the file would already be sparse, so I don't think that will
>> help in this case...
> 
> But only if other tools originally used them, and there will probably be plenty
> of cases where they don't, or legacy files, or ....

I was thinking that the suggestion was to use SEEK_HOLE/SEEK_DATA to find
the holes in the file...  Of course, it makes a lot of sense if you use
them to skip the existing holes, and only look for strings of zeros in the
data parts...

Cheers, Andreas





