From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 12:31:56 -0500
Message-ID: <4DCD6B0C.9050805@redhat.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>	<20110513145608.GA21165@thunk.org>	<4DCD4D5E.6050307@redhat.com> <BANLkTim8ihBNzxxkoTwigKMQB1xHToevdQ@mail.gmail.com> <4DCD6A2D.30504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DCD6A2D.30504@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/13/11 12:28 PM, Eric Sandeen wrote:
>> After xfstests failed to build on Ubuntu 10.10,  I followed the advice omitted
>> > by the build script to run "make install-qa", to solve the problem.
>> > It took me a while to figure exactly where I should run the command,
>> > but in the end I pulled the xfsprogs tree, ran "make; make install;
>> > make install-qa"
>> > and from there on things were looking better.
> I can ask Nathan if he can package the qa bits for debian.
> 
> Or, you all could just use Fedora ;)
> 
> -Eric

oh, or maybe all those files are already in xfslibs-dev:

http://packages.debian.org/lenny/amd64/xfslibs-dev/filelist

Can someone who has encountered xfstests build problems send a bug report to the xfs list please?
I'm sure we can get it sorted.

-Eric
