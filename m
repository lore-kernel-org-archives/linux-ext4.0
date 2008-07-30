From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 1/2] ext3: add an option to control error handling on file data
Date: Wed, 30 Jul 2008 11:14:02 -0400
Message-ID: <170fa0d20807300814o7741859eu8ad5d5b3b95e401c@mail.gmail.com>
References: <488FD756.9060106@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	tglx@linutronix.de, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762796AbYG3POV@vger.kernel.org>
In-Reply-To: <488FD756.9060106@hitachi.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 29, 2008 at 10:52 PM, Hidehiro Kawai
<hidehiro.kawai.ez@hitachi.com> wrote:
> If the journal doesn't abort when it gets an IO error in file data
> blocks, the file data corruption will spread silently.  Because
> most of applications and commands do buffered writes without fsync(),
> they don't notice the IO error.  It's scary for mission critical
> systems.  On the other hand, if the journal aborts whenever it gets
> an IO error in file data blocks, the system will easily become
> inoperable.  So this patch introduces a filesystem option to
> determine whether it aborts the journal or just call printk() when
> it gets an IO error in file data.
>
> If you mount a ext3 fs with data_err=abort option, it aborts on file
> data write error.  If you mount it with data_err=ignore, it doesn't
> abort, just call printk().  data_err=abort is default, because
> people have used this error handling policy for three years.

Hidehiro,

Thanks for making this configurable!

But given how surprised many of us were when we found out that
jbd/ext3 has been aborting on file data blocks isn't this our chance
to correct that long-standing oversight?  Shouldn't the default be
data_err=ignore?  Or would changing this behavior cause more harm than
good?

I don't feel strongly either way, having the "data_err" option makes
this issue moot for me, but I figured I'd raise the question (in the
interest of review).

Mike
