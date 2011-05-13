From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 13:34:53 +0300
Message-ID: <BANLkTin7REAcZeAuY1RmWy5WUtvh1Z+WVw@mail.gmail.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
	<BANLkTinnRNT6vG3JQ7j8p1Acg92_caHDOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: sedat.dilek@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTinnRNT6vG3JQ7j8p1Acg92_caHDOQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 13, 2011 at 12:27 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> On Fri, May 13, 2011 at 11:17 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Hi All,
>>
>> I double checked myself and made a clean build of 2.6.39-rc7
>> and I am still getting this crash below with xfstest 232.
>> All xfstests used to pass when I was runing kernel 2.6.38, so
>> this must be a regression.
>>
>> Unfortunately, I cannot double check there is no crash with previous kernel,
>> because I lost connection with my test server and there is no one to
>> push the reset button over the weekend.
>>
>> Can anyone try to reproduce the error with xfstest 005 and the crash
>> with xfstest 232?
>>
>> Thanks,
>> Amir.
>>
>
> Please attach your kernel-config for reproducible testing!

Well, maybe next time, as I said, now my remote testing server
is unreachable.
Not that it helps, but my config file originated from Ubuntu 10.10
kernel (2.6.35-generic) and I added some kernel hacking options,
like LOCKDEP and friends.
I had CONFIG_EXT4_DEBUG and CONFIG_JBD2_DEBUG on.
All the rest was just defaults chosen by make oldconfig.
If it helps, I can send you a config file from my laptop, which
is supposed to be similar to the one on the server
(before the changes made my make oldconfig).

>
> Is this really with 2.6.39-rc7 vanilla kernel (no extra patches!)?
>

git checkout v2.6.39-rc7
make clean && make

Reported kernel version doesn't lie when you're building from GIT
and I didn't edit any files manually.


> Which xfstest (GIT) version is this?

I was using the current (GIT) version, fetched it 2 days ago.
I do have some weird problem on my system, which I reported to XFS list
a while back and couldn't find a cure:
the execution of "umount ; fsck" after the tests sometimes fails to
umount (EBUSY)
after specific tests.

I suspect that this problem in my system is also related to the crash,
because test 232 does 2 remounts and that may cause some race on my system.


> Which versions of xfs{progs, -libs, dump}?

Whatever tools came with the Ubuntu 11.4 upgrade... (cannot check now)
I suppose e2fsprogs version is what matters when I am checking ext4 though.

>
> Here I am on i386 and can help with testing if this helps.
>

Great! so did you try running xfstests 005 and 232?
Did they pass?

Thanks,
Amir.

> - Sedat -
>
