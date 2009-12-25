From: tytso@mit.edu
Subject: Re: [PATCH] ext4: return correct wbc.nr_to_write in
 ext4_da_writepages
Date: Fri, 25 Dec 2009 15:10:48 -0500
Message-ID: <20091225201048.GF32757@thunk.org>
References: <1261063063.4882.38.camel@castor>
 <4B2A50E9.4010806@redhat.com>
 <20091217173232.GA2950@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Richard Kennedy <richard@rsk.demon.co.uk>, adilger@sun.com,
	linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756607AbZLYUL1@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091217173232.GA2950@skywalker.linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 17, 2009 at 11:02:32PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Dec 17, 2009 at 09:40:25AM -0600, Eric Sandeen wrote:
> > Richard Kennedy wrote:
> > > ext4: always re-base nr_to_write in ext4_da_writepages
> > > 
> > > When ext4_da_writepages increases the nr_to_write in writeback_control
> > > then it must always re-base the return value.
> > > 
> > > Without this change, when wb_writeback calculates how many pages were
> > > actually written it can get a negative value and loop more times than
> > > necessary. In tests I have seen nearly all the dirty pages pushed out to
> > > writeback due to this issue.
> > > 
> > > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Added to the ext4 patch queue, thanks.

				- Ted
