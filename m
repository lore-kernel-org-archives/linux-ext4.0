From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] xfstests: add disk failure simulation test
Date: Tue, 19 Feb 2013 15:14:25 +0400
Message-ID: <87bobg8sj2.fsf@openvz.org>
References: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org> <511BBF33.20908@redhat.com> <87621vngtw.fsf@openvz.org> <511CFFA2.8030905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dchinner@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <511CFFA2.8030905@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 14 Feb 2013 09:15:46 -0600, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/14/13 7:52 AM, Dmitry Monakhov wrote:
> > On Wed, 13 Feb 2013 10:28:35 -0600, Eric Sandeen <sandeen@redhat.com> wrote:
> >> On 2/13/13 9:41 AM, Dmitry Monakhov wrote:
> 
> <snip>
> 
> >>> +# get standard environment, filters and checks
> >>> +. ./common.rc
> >>> +. ./common.filter
> >>> +
> >>> +# TODO move it to common.blkdev if necessery
> >>
> >> maybe a comment as to why you do this?  (presumably to find the right thing in /sys)
> >> I hope this always works with all udev schemes etc?
> > I just ment to say that functions below are good candidates to became
> > common wrappers.
> 
> Sure, but what is the reason for the wrapper?
> 
> On inspection I think its' because you need the right sysfs name; it'd
> just be nice to say that it's the reason for the readlink/basename
> frobbing of the existing $SCRATCH_DEV.  Not a huge deal.
Most people use LVM's names similar to /dev/vg/log1, but real name is
/dev/md-xxx, also some fancy SCSI targets may has crazy names.
> 
> >>> +SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
> >>> +SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
> >>> +
> 
> <snip>
> 
> >>> +_require_debugfs()
> >>> +{
> >>> +    #boot_params always present in debugfs
> >>> +    [ -d "$DEBUGFS_MNT/boot_params" ] || _notrun "Debugfs not mounted"
> >>> +}
> >>
> >> Would it make more sense to look for debugfs in /proc/filesystems
> >> as a test for it being *available* (as opposed to mounted somewhere?)
> >>
> >> I wonder if a helper (maybe in _require_debugfs) should work out if
> >> it's mounted, if not, try to mount it, and in the end, export DEBUGFS_MNT
> >> for any test that wants to use it.
> >>
> >> Otherwise if it happens to be mounted elsewhere, this'll all fail.
> >> Just a thought.  Maybe that's unusual enough that there's no point.
> >> But getting it mounted if it's not would be helpful I think.
> 
> Any thoughts on this?  As it stands it requires debugfs to be
> at /sys/kernel/debug (by default) *and* mounted prior to the test run.
> So it's another (maybe unexpected) piece of pre-test setup which might
> result in this test not getting run.
I just try to preserve blktrace(8) behaviour which complain if
debugfs is absent. IMHO debugfs is MUST_HAVE feature for testing environment.
So if not mounted it was done with purpose.
> 
> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
