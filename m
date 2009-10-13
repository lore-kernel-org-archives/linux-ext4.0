From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [Bug 14354] Status of barrier requests in LVM and
	dm-crypt?
Date: Tue, 13 Oct 2009 10:49:45 -0400
Message-ID: <20091013144945.GA22223@redhat.com>
References: <E1MxPQM-00074N-Ph@closure.thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <E1MxPQM-00074N-Ph@closure.thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 12 2009 at  2:15pm -0400,
Theodore Ts'o <tytso@mit.edu> wrote:

> Hi, I'm trying to track down a problem relating to ext4 problems, in
> kernel bugzilla 14354.  Originally it was thought this was a regression
> 2.6.31->2.6.32-rc1 regression, but the Aneesh Kumar's report shows a
> very similar fsck transcript using a 2.6.30-1 kernel (which makes makes
> it unclear whether this is really a regression or not), and all three
> reports are tied together by the use of device-mapper.  
> 
> The fsck logs are consistent barriers being disabled.  As I recall under
> some circumstances device mapper silently drops barrier requests --- I
> thought this was fixed for device mapper in some cases.  What's the
> current status of barrier requests in device mapper?  Are they
> faithfully passed for standard (non-RAID) LVM2 volumes?  When was this
> changed?   What about dm-crypto volumes?  (One of the reports was with a
> dm-crypt volume from what I can tell.)

Barrier infrastructure started to get added to the DM core in 2.6.30, see:
http://git.kernel.org/linus/af7e466a1ace

But barriers were not enabled for all DM targets (_except_ dm-multipath)
until 2.6.31.  So 2.6.31's dm-crypt does support barriers, see:
http://git.kernel.org/linus/647c7db14ef9

If the underlying device(s) support barriers DM should faithfully pass
them on (again except for dm-multipath).  Also, requests with barriers
that result in -EOPNOTSUPP are retried without the barrier, see:
http://git.kernel.org/linus/51aa32284958

Mike
