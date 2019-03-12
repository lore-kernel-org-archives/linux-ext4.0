Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE4FC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 02:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88096214AE
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 02:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zeMc++Z3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfCLCeK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Mar 2019 22:34:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfCLCeK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2019 22:34:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2C2Xv9H165286;
        Tue, 12 Mar 2019 02:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=KRH9tTBgEc/2fs7lVAZ+hSCMJHtcY+XSDCmsG0GgBZo=;
 b=zeMc++Z35Agd2ZgoSA9RZjinvcKPTiC3ymIlN8JRtXf0t0a2kmrTl50ddIwGc1WrIV+0
 nrxbaGVz/O9u6wLAF/cBeeJlyYraHo5WpTBXiuHzRHt9v69JPRQ/qUOKeycGOLuaiPa4
 7sB+TXLXGAVmCb2B3FhTOULOUS9CEPcAdzLGHclEgTb8Eg/KKpgQ5+bzSSDM4oFRfb09
 rXAhvpzsAQMIkeEf44nqZBRtV343l2bMRnFB67yP8kDjzVdi+uRz9QBF8N41HMuQvy0B
 ZLHy4P25+uufIas3NmIPhK/3qtuSHtZLeBGro3XLqhpTlGnGI2Zk3CLYCj1p3lu0zmZZ Ag== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2r464r9t4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Mar 2019 02:33:56 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2C2XuCU017808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Mar 2019 02:33:56 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2C2XtFK000692;
        Tue, 12 Mar 2019 02:33:55 GMT
Received: from localhost (/10.159.236.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Mar 2019 19:33:55 -0700
Date:   Mon, 11 Mar 2019 19:33:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Sven Hartge <sven@svenhartge.de>, 924275@bugs.debian.org,
        linux-ext4@vger.kernel.org, control@bugs.debian.org
Subject: Re: Bug#924275: Pulls in lvm2 packages on systems not needing them
Message-ID: <20190312023346.GJ20533@magnolia>
References: <155224974445.827475.8622512417054538613.reportbug@ds9.feds.ath.cx>
 <20190311002208.GA4486@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311002208.GA4486@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=29 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903120017
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Mar 10, 2019 at 08:22:08PM -0400, Theodore Ts'o wrote:
> tag 924275 +pending
> thanks
> 
> On Sun, Mar 10, 2019 at 09:29:04PM +0100, Sven Hartge wrote:
> > 
> > While I like the new fsck-via-LVM-snapshot feature, I think adding lvm2
> > to Recommends is too agressive here.
> > 
> > On systems not using LVM this will needlessly pull in the whole LVM/DM
> > machinery, including changes to the initramfs, as long as apt is in its
> > default "install-recommends" configuration.
> > 
> > Only on systems where the system admin has changed the default to
> > "no-install-recommends" nothing will happen.
> 
> Agreed; thanks for pointing this out!  I have the following patches
> queued for the next release.

FWIW they look ok to me (who doesn't have auto-install of Recommends),
so:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 				- Ted
> 

> From 04738f2ff3b8a2acaf2de09856e07601817350b5 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sun, 10 Mar 2019 19:41:11 -0400
> Subject: [PATCH 1/2] e2scrub: check to make sure lvm2 is installed
> 
> Not all systems will have the lvm2 package installed, so check for
> that.  Pretty much all systems should have util-linux installed, but
> check for that as well.
> 
> Of course, if lvm2 is installed we shouldn't find any LVM devices ---
> but eventually the Demon Murphy will find a way to make it happen. :-)
> 
> Also, set the PATH so we don't have to worry about the script failing
> due to /sbin not being in the path.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub.in     | 12 ++++++++++++
>  scrub/e2scrub_all.in | 16 ++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
> index e1965db4e..51a909373 100644
> --- a/scrub/e2scrub.in
> +++ b/scrub/e2scrub.in
> @@ -23,6 +23,8 @@
>  # check filesystems in VGs that have at least 256MB (or so) of
>  # free space.
>  
> +PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
> +
>  snap_size_mb=256
>  fstrim=0
>  reap=0
> @@ -82,6 +84,16 @@ if [ -z "${arg}" ]; then
>  	exitcode 1
>  fi
>  
> +if ! type lsblk >& /dev/null ; then
> +    echo "e2scrub: can't find lsblk --- is util-linux installed?"
> +    exitcode 1
> +fi
> +
> +if ! type lvcreate >& /dev/null ; then
> +    echo "e2scrub: can't find lvcreate --- is lvm2 installed?"
> +    exitcode 1
> +fi
> +
>  # Find the device for a given mountpoint
>  dev_from_mount() {
>  	local mountpt="$(realpath "$1")"
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index 23d122d25..d725a7f2e 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -18,6 +18,8 @@
>  #  along with this program; if not, write the Free Software Foundation,
>  #  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>  
> +PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
> +
>  scrub_all=0
>  conffile="@root_sysconfdir@/e2scrub.conf"
>  
> @@ -68,6 +70,20 @@ while getopts "ArV" opt; do
>  done
>  shift "$((OPTIND - 1))"
>  
> +# If some prerequisite packages are not installed, exit with a code
> +# indicating success to avoid spamming the sysadmin with fail messages
> +# when e2scrub_all is run out of cron or a systemd timer.
> +
> +if ! type lsblk >& /dev/null ; then
> +    echo "e2scrub_all: can't find lsblk --- is util-linux installed?"
> +    exitcode 0
> +fi
> +
> +if ! type lvcreate >& /dev/null ; then
> +    echo "e2scrub_all: can't find lvcreate --- is lvm2 installed?"
> +    exitcode 0
> +fi
> +
>  # Find scrub targets, make sure we only do this once.
>  ls_scrub_targets() {
>  	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
> -- 
> 2.19.1
> 

> From 212ba2a8a81001bce21cce314f9bc2967f2df7c7 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sun, 10 Mar 2019 20:01:58 -0400
> Subject: [PATCH 2/2] debian: drop lvm2 from the recommends line
> 
> If the user doesn't intend to use lvm2, and it's not installed,
> installing e2fsprogs shouldn't drag it (and all of its dependencies)
> into the system.
> 
> Addresses-Debian-Bug: 924275
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 1bb8adb15..e454687f9 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -191,7 +191,7 @@ XB-Important: yes
>  Pre-Depends: ${shlibs:Depends}, ${misc:Depends}, libblkid1, libuuid1
>  Multi-Arch: foreign
>  Suggests: gpart, parted, fuse2fs, e2fsck-static
> -Recommends: e2fsprogs-l10n, lvm2
> +Recommends: e2fsprogs-l10n
>  Architecture: any
>  Description: ext2/ext3/ext4 file system utilities
>   The ext2, ext3 and ext4 file systems are successors of the original ext
> -- 
> 2.19.1
> 

