From: Kevin Liao <kevinlia@gmail.com>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Thu, 30 Oct 2014 16:15:45 +0800
Message-ID: <CAF_MivGWF6BVZbztKSHQ+EKNkfm-9UhZ61fKXZzpfXdL=2RhvA@mail.gmail.com>
References: <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com>
 <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos>
 <544E7144.4080809@windriver.com> <alpine.DEB.2.11.1410291854090.5308@nanos>
 <54513BDA.1050804@windriver.com> <alpine.DEB.2.11.1410292013510.5308@nanos>
 <20141029231916.GD5000@thunk.org> <54517A1F.1060102@windriver.com> <20141030014405.GE5000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Friesen <chris.friesen@windriver.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	adilger.kernel@dilger.ca, rt-users <linux-rt-users@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20141030014405.GE5000@thunk.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2014-10-30 9:44 GMT+08:00 Theodore Ts'o <tytso@mit.edu>:
> On Wed, Oct 29, 2014 at 05:37:03PM -0600, Chris Friesen wrote:
>> 3) For 3.4, do you think that it's sufficient to backport the three commits
>> I mentioned, or are you aware of others that I should be looking at as well?
>
> No, those three commits would be quite sufficient.  If you could
> handle doing the backports, I would greatly appreciate it!  Sounds
> like you've done so for 3.4 already, and it should be fairly
> straightforward to get them into 3.10, since b34090e landed in 3.11.
>

Hi Ted and Chris,

I also have similar jbd2 hang problem for kernel 3.4. Could you kindly
specify what are the three commits to fix the issue? Cause I can not
find them using the keyword "commit b34090e e5a120a f5113ef".

Thanks a lot for your help.

Kevin
