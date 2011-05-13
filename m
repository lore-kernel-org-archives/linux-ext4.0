From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 11:27:18 +0200
Message-ID: <BANLkTinnRNT6vG3JQ7j8p1Acg92_caHDOQ@mail.gmail.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 13, 2011 at 11:17 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi All,
>
> I double checked myself and made a clean build of 2.6.39-rc7
> and I am still getting this crash below with xfstest 232.
> All xfstests used to pass when I was runing kernel 2.6.38, so
> this must be a regression.
>
> Unfortunately, I cannot double check there is no crash with previous kernel,
> because I lost connection with my test server and there is no one to
> push the reset button over the weekend.
>
> Can anyone try to reproduce the error with xfstest 005 and the crash
> with xfstest 232?
>
> Thanks,
> Amir.
>

Please attach your kernel-config for reproducible testing!

Is this really with 2.6.39-rc7 vanilla kernel (no extra patches!)?

Which xfstest (GIT) version is this?
Which versions of xfs{progs, -libs, dump}?

Here I am on i386 and can help with testing if this helps.

- Sedat -
