From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v3 00/13] vfs: hot data tracking
Date: Thu, 18 Oct 2012 16:17:03 +1100
Message-ID: <20121018051703.GR2739@dastard>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <20121015204217.GB2739@dastard>
 <CAEH94Lgfev1qg2S+2-D5VMtVgSES3cFw0KmJSJr5HObyhA8sbg@mail.gmail.com>
 <20121018042916.GP2739@dastard>
 <CAEH94LhtzMkKTVD_yDvotDMwkfFZbXObYVCPAzpZOcNVqxDxpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEH94LhtzMkKTVD_yDvotDMwkfFZbXObYVCPAzpZOcNVqxDxpQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 18, 2012 at 12:44:47PM +0800, Zhi Yong Wu wrote:
> On Thu, Oct 18, 2012 at 12:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Oct 17, 2012 at 04:57:14PM +0800, Zhi Yong Wu wrote:
> >> On Tue, Oct 16, 2012 at 4:42 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Wed, Oct 10, 2012 at 06:07:22PM +0800, zwu.kernel@gmail.com wrote:
> >> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> > ....
> >> > (*) Tested on an empty 17TB XFS filesystem with:
> >> >
> >> > $ sudo mkfs.xfs -f -l size=131072b,sunit=8 /dev/vdc
> >> > meta-data=/dev/vdc               isize=256    agcount=17, agsize=268435455 blks
> >> >          =                       sectsz=512   attr=2, projid32bit=0
> >> > data     =                       bsize=4096   blocks=4563402735, imaxpct=5
> >> >          =                       sunit=0      swidth=0 blks
> >> > naming   =version 2              bsize=4096   ascii-ci=0
> >> > log      =internal log           bsize=4096   blocks=131072, version=2
> >> >          =                       sectsz=512   sunit=1 blks, lazy-count=1
> >> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >> > $ sudo mount -o logbsize=256k /dev/vdc /mnt/scratch
> >> > $ sudo chmod 777 /mnt/scratch
> >> > $ fs_mark  -D  10000  -S0  -n  100000  -s  1  -L  63  -d \
> >> > /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d \
> >> > /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d \
> >> > /mnt/scratch/6  -d  /mnt/scratch/7
> >> > .....
> >> >      0     21600000            1      16679.3         12552262
> >> >      0     22400000            1      15412.4         12588587
> >> >      0     23200000            1      16367.6         14199322
> >> >      0     24000000            1      15680.4         15741205
> >> > <hangs here w/ OOM>
> >> ^^^^In this test, i haven't see you enable hot_track function via
> >> mount, why did it meet OOM?
> >
> > I copied the wrong mount command. It was definitely enabled.
> OK, BTW: fs_mark is the script written by you? After xfsprogs is
> installed, i haven't found this command.

# apt-get install fsmark

Or get the source here:

http://sourceforge.net/projects/fsmark/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
