From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Date: Fri, 2 Feb 2018 14:20:23 +1100
Message-ID: <20180202032023.l644wdfecdm3eqdp@destitution>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
 <20180201234413.idd27uqzqbg54ddk@destitution>
 <76cbab51-9f18-8531-016e-4e1f3c43637b@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <76cbab51-9f18-8531-016e-4e1f3c43637b-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 01, 2018 at 05:13:40PM -0700, Dave Jiang wrote:
> 
> 
> On 02/01/2018 04:44 PM, Dave Chinner wrote:
> > On Thu, Feb 01, 2018 at 01:33:05PM -0700, Dave Jiang wrote:
> >> When using realtime device (rtdev) with xfs where the data device is not
> >> DAX capable, two issues arise. One is when data device is not DAX but the
> >> realtime device is DAX capable, we currently disable DAX.
> >> After passing this check, we are also not marking the inode as DAX capable.
> >> This change will allow DAX enabled if the data device or the realtime
> >> device is DAX capable. S_DAX will be marked for the inode if the file is
> >> residing on a DAX capable device. This will prevent the case of rtdev is not
> >> DAX and data device is DAX to create realtime files.
> > 
> > I'm confused by this description. I'm not sure what is broken, nor
> > what you are trying to fix.
> > 
> > I think what you want to do is enable DAX on RT devices separately
> > to the data device and vice versa?
> > 
> > i.e. is this what you are trying to acheive?
> > 
> > datadev dax	rtdev dax		DAX enabled on
> > -----------     ---------		--------------
> > no		no			neither
> > yes		no			datadev
> > no		yes			rtdev
> > yes		yes			both
> 
> ^ Yes that's pretty much what I was trying to say. I probably should've
> just provided the table above.

Ok, good to know I understood what you want to achieve. Now we've
just got to work out how to do it. :)

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
