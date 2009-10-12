From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [Bug 14354] Status of barrier requests in LVM and
	dm-crypt?
Date: Mon, 12 Oct 2009 14:15:10 -0400
Message-ID: <E1MxPQM-00074N-Ph@closure.thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Cc: linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
To: dm-devel@redhat.com
Return-path: <dm-devel-bounces@redhat.com>
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

Hi, I'm trying to track down a problem relating to ext4 problems, in
kernel bugzilla 14354.  Originally it was thought this was a regression
2.6.31->2.6.32-rc1 regression, but the Aneesh Kumar's report shows a
very similar fsck transcript using a 2.6.30-1 kernel (which makes makes
it unclear whether this is really a regression or not), and all three
reports are tied together by the use of device-mapper.  

The fsck logs are consistent barriers being disabled.  As I recall under
some circumstances device mapper silently drops barrier requests --- I
thought this was fixed for device mapper in some cases.  What's the
current status of barrier requests in device mapper?  Are they
faithfully passed for standard (non-RAID) LVM2 volumes?  When was this
changed?   What about dm-crypto volumes?  (One of the reports was with a
dm-crypt volume from what I can tell.)

Thanks,

						- Ted
