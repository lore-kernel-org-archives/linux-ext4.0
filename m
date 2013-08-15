From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 08:14:21 -0700
Message-ID: <520CF04D.7020002@linux.intel.com>
References: <520BB9EF.5020308@linux.intel.com>
	<20130814194359.GA22316@thunk.org> <520BED7A.4000903@intel.com>
	<20130814230648.GD22316@thunk.org>
	<CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
	<20130815011101.GA3572@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130815011101.GA3572@thunk.org>
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

On 08/14/2013 06:11 PM, Theodore Ts'o wrote:
> The point is that if the goal is to measure page fault scalability, we
> shouldn't have this other stuff happening as the same time as the page
> fault workload.

will-it-scale does several different tests probing at different parts of
the fault path:

https://www.sr71.net/~dave/intel/willitscale/systems/bigbox/3.11.0-rc2-dirty/foo.html

It does that both for process and threaded workloads which lets it get
pretty good coverage of different areas of code.

I only posted data from half of one of these tests here because it was
the only one that I found that both had noticeable overhead in the
filesystem code.  It also showed substantial, consistent, and measurable
deltas between the different filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
