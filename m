From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwin@etorok.net>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Wed, 17 Aug 2016 17:27:25 +0300
Message-ID: <8b8fff2d-5c89-856a-65d2-f6962b875f8f@etorok.net>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
 <20160805191548.GD19960@birch.djwong.org> <20160808035634.GA16193@thunk.org>
 <20160808062810.GC8590@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Johannes Stezenbach <js@sig21.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160808062810.GC8590@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2016-08-08 09:28, Darrick J. Wong wrote:
> On Sun, Aug 07, 2016 at 11:56:34PM -0400, Theodore Ts'o wrote:
>> On Fri, Aug 05, 2016 at 12:15:48PM -0700, Darrick J. Wong wrote:
>>>>> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/ext4/inode.c?id=b47820edd1634dc1208f9212b7ecfb4230610a23
>>>>
>>>> I added the patch, rebuilt and rebooted.  It will take some time
>>>> before I'll report back since the issue is so hard to reproduce.
>>>
>>> FWIW I could trigger it reliably by running a bunch of directory traversal
>>> programs simultaneously on the same directory.  I have a script that fires
>>> up multiple mutts pointing to the Maildirs for the high traffic Linux lists.
>>
>> Hmm, I wonder if we should request that this patch be backported to
>> -stable.  Darrick, what do you think?
> 
> Seems like an excellent idea.

Hi,

I see 4.7.1. was released, however before testing it in the changelog I can't see the inode.c commit with the checksum fix.
Is there another commit that would provide an equivalent fix, or is the fix not part of 4.7.1?

Best regards,
--Edwin
