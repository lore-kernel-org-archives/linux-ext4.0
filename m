From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
Date: Mon, 21 Jul 2014 15:11:48 -0400
Message-ID: <20140721191148.GB24960@thunk.org>
References: <53C47E59.8030502@gmail.com>
 <20140715093154.GB1451@thunk.org>
 <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Olof Johansson <olof@lixom.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 21, 2014 at 10:40:02AM -0700, Olof Johansson wrote:
> > I'll respin the "ext4: rearrange initialization to fix EXT4FS_DEBUG"
> > commit to include this fix and give you credit in the commit logs for
> > pointing out this issue.
> 
> Friendly ping, since all !SMP builds in -next seem to be broken by this still.

Right, sorry, I'm currently in vacation in Rome, and the network
connection was really lousy here now that I'm no longer at the ACACES
summer school in Fiuggi.  (Also, now that I'm no longer actually
teaching, I've beeen trying to actually do the disconnecting and
sightseeing thing.  :-)

Pushed now.

						- Ted
