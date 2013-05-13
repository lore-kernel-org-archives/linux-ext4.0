From: Tony Luck <tony.luck@gmail.com>
Subject: Re: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Sun, 12 May 2013 20:11:59 -0700
Message-ID: <CA+8MBb+51dMaYQd-g-T40+UstbxsSbmewSXiUfNDrVouSA3=Zw@mail.gmail.com>
References: <7032562.14371368411664268.JavaMail.weblogic@epml07>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: eunb.song@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7032562.14371368411664268.JavaMail.weblogic@epml07>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 12, 2013 at 7:21 PM, EUNBONG SONG <eunb.song@samsung.com> wrote:
> Hi, my git bisect result is same yours. And i reported that to community yesterday.

Ah. Good to have some confirmation (I was never sure how long to keep
running before deciding that a test was "good".  My slowest "bad" test took
about 2.5 hours.  I mostly let the tests run for >6 hours before deciding.

I just confirmed that 3.10-rc1 still fails (30 minutes).  Now running a test
on 3.10-rc1 with just this commit reverted. Only been going for about
15 minutes, so no useful information yet.

My best guess as to why this commit causes problems is that there are places
where updates to individual fields in this structure used to be independent
because they were to whole words.  Now we have bitfileds there are races
between access to different fields in the same word.

-Tony
