Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15B0C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFADA218B0
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="omlQq5C5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfCUDzc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:55:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48894 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfCUDzb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 23:55:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3sSvD082689;
        Thu, 21 Mar 2019 03:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Q/4MToEFGxDdkYXJjs8KNUPH+yY5KbHpNypI+TI8YPs=;
 b=omlQq5C5w5ew7sufrOKqhM3sRir/hNxNZEG+pHScs6ByGYzha6m1YfnJajhOdi7mKuEV
 HSsLEpgbmJYyoROFjh+VsOkC8iW1Sq189J7YyC1O4q+iu0EotuFfENortfNKZ+ax4FzS
 Uh4+PEcQViCwTQa1XTFifPNP/fL/iw2lJSaxq/7wJvEMJ39yblLoqUND1MlQGNwHc1uT
 X57Q/s7b1kvfJ8pKEJPVoAH4UsP1i+w1a10918l88hRmyYyRRZk2t3D2WmDEaVTGjFb3
 oQlWVavEy6bfYK+cEkSYte1ZmcwufIvmM08z1ZY0mBKl9mvtEwjqJKmtKWwKirtwuNjw UA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2r8ssrp4pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 03:55:29 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2L3tTaN021488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 03:55:29 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L3tSY7017577;
        Thu, 21 Mar 2019 03:55:28 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 20:55:28 -0700
Date:   Wed, 20 Mar 2019 20:55:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/9] e2scrub: check to make sure lvm2 is installed
Message-ID: <20190321035530.GA1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-1-tytso@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9201 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=29 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903210025
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:10PM -0400, Theodore Ts'o wrote:
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

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
