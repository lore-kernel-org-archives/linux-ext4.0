From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Wed, 02 Jan 2013 09:17:27 -0600
Message-ID: <50E44F87.5060102@redhat.com>
References: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com> <20121227062907.GA5001@gmail.com> <87mwwzq5t7.fsf@openvz.org> <20121227134413.GA20671@thunk.org> <20121229002131.GA3120@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab3ABPRt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 10:17:49 -0500
In-Reply-To: <20121229002131.GA3120@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/28/12 6:21 PM, Dave Chinner wrote:
> On Thu, Dec 27, 2012 at 08:44:13AM -0500, Theodore Ts'o wrote:
>> On Thu, Dec 27, 2012 at 12:04:36PM +0400, Dmitry Monakhov wrote:
>>> In fact this is my fault that we still not have autotest for that.
>>> I'm think of add crash-test to xfstests which should trigger journal
>>> abort and forced umount. Later test should mount FS which trigger
>>> journal_replay and orphan_cleanup.
>>
>> We could create some tests in xfstests which force a crash via "echo b
>>> /proc/sysrq-trigger", but the trick is would require xfstests to
>> install something in the /etc/rc scripts so xfstests could resume
>> right after it came back --- and perhaps to echo something to the
>> console which automated test runners (such as the one I use which I've
>> published at [1] could capture so they would know that they should
>> restart the system.
>>
>> [1] git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
>>
>> For now the simplest way to test this is to use the file system image
>> in tests/f_orphan_extents_inode/image.gz, and make this be an
>> ext4-specific test.  This is how I tested it when I created my fix (in
>> parallel with Zheng's patch).  The compressed file system image is
>> only 564 bytes --- and was made deliberately w/o a journal so it could
>> be that small --- and the lack of a journal was how I found the
>> infinite loop problem which was fixed in the 2/2 patch in my patches.
>> So including this compressed fs image in xfstests is probably the way
>> I would suggest for now.
> 
> Just implement XFS_IOC_GOINGDOWN. That way xfstests will immediately
> support shutting down the filesystem via the src/godown utility.
> The default XFS behaviour is to freeze the filesystem, then do a
> forced shutdown on it, though it can also just trigger shutdowns
> with and without first flushing the journal.
> 
> i.e.  it sounds like test 121 is pretty much what you are describing
> here...
> 
> Cheers,
> 
> Dave.
> 

Agreed, if the xfs testing ioctl semantics make sense across other
filesystems, it would be great to just re-use that, and voila, instant
test framework becomes available.

-Eric
