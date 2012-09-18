From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 08:21:35 +0200
Message-ID: <CANGUGtCJV+nsMrM0SBjxg-CPO-XqRret4HPTtPHRaOPSFW8yYg@mail.gmail.com>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <nsxa9wojdcd.fsf@closure.thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/9/18 Theodore Ts'o <tytso@mit.edu>:
>
> Does anyone have test cases for SEEK_HOLE/SEEK_DATA handy?  As near as I
> can tell xfstests doesn't have any tests for SEEK_HOLE/SEEK_DATA
> functionality, and I was hoping someone had some test programs and test
> sets already written.
>
> Thanks!!
>
>                                                         - Ted


Hi,

under the folder "test" here
(http://pramfs.git.sourceforge.net/git/gitweb-index.cgi) you can find
the test lseek.c

Regards,

Marco
