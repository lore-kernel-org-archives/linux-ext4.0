From: David Lang <david@lang.hm>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Mon, 19 Aug 2013 16:23:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1308191621130.30740@nftneq.ynat.uz>
References: <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
	<CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
	<20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
	<CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
	<20130815060149.GP6023@dastard>
	<CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
	<20130815071141.GQ6023@dastard>
	<20130815074531.GA2147@quack.suse.cz>
	<20130815212826.GS6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
	Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, xfs@oss.sgi.com,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130815212826.GS6023@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Aug 2013, Dave Chinner wrote:

> The problem with "not exported, don't update" is that files can be
> modified on server startup (e.g. after a crash) or in short
> maintenance periods when the NFS service is down. When the server is
> started back up, the change number needs to indicate the file has
> been modified so that clients reconnecting to the server see the
> change.
>
> IOWs, even if the NFS server is not up or the filesystem not
> exported we still need to update change counts whenever a file
> changes if we are going to tell the NFS server that we keep them...

This sounds like you need something more like relctime rather than noctime, 
something that updates the time in ram, but doesn't insist on flushing it to 
disk immediatly, updating when convienient or when the file is closed.

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
