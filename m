From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 21:11:01 -0400
Message-ID: <20130815011101.GA3572@thunk.org>
References: <520BB9EF.5020308@linux.intel.com>
 <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com>
 <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 14, 2013 at 04:38:12PM -0700, Andy Lutomirski wrote:
> > It would be better to write zeros to it, so we aren't measuring the
> > cost of the unwritten->written conversion.
> 
> At the risk of beating a dead horse, how hard would it be to defer
> this part until writeback?

Part of the work has to be done at write time because we need to
update allocation statistics (i.e., so that we don't have ENOSPC
problems).  The unwritten->written conversion does happen at writeback
(as does the actual block allocation if we are doing delayed
allocation).

The point is that if the goal is to measure page fault scalability, we
shouldn't have this other stuff happening as the same time as the page
fault workload.

						- Ted
