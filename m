Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FC0C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 10:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A99218E2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 10:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfCUK56 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:57:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfCUK55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 06:57:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B6B38B943;
        Thu, 21 Mar 2019 10:57:57 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FDC4601AE;
        Thu, 21 Mar 2019 10:57:56 +0000 (UTC)
Date:   Thu, 21 Mar 2019 11:57:51 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 5/9] e2fscrub: add the -n option which shows what
 commands e2scrub would execute
Message-ID: <20190321105751.l7vlfhzmufgu3dfn@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-5-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-5-tytso@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 21 Mar 2019 10:57:57 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:14PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub.8.in | 5 +++++
>  scrub/e2scrub.in   | 6 ++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/scrub/e2scrub.8.in b/scrub/e2scrub.8.in
> index ff03523e3..7342876a3 100644
> --- a/scrub/e2scrub.8.in
> +++ b/scrub/e2scrub.8.in
> @@ -38,6 +38,11 @@ If the filesystem is not repaired,
>  will be run before the next mount.
>  .SH OPTIONS
>  .TP
> +\fB-n\fR
> +Print what commands
> +.B e2scrub
> +would execute (but don't actually execute them).

We should be a bit more clear that it's not all the commands that will
be printed but not executed. Some of commands, like lsblk and lvs will
actually be executed so it's not like you can run this without proper
privledges.

It sounds nit-picky, and obvious to us, but I am sure someone will
complaing about this.

-Lukas

> +.TP
>  \fB-r\fR
>  Remove the e2scrub snapshot and exit without checking anything.
>  .TP
> diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
> index 51a909373..301574968 100644
> --- a/scrub/e2scrub.in
> +++ b/scrub/e2scrub.in
> @@ -37,6 +37,7 @@ print_help() {
>  	echo "Usage: $0 [OPTIONS] mountpoint | device"
>  	echo
>  	echo "mountpoint must be on a LVM-managed block device"
> +	echo "-n: Show what commands e2scrub would execute."
>  	echo "-r: Remove e2scrub snapshot and exit, do not check anything."
>  	echo "-t: Run fstrim if successful."
>  	echo "-V: Print version information and exit."
> @@ -68,8 +69,9 @@ exitcode() {
>  	exit "${ret}"
>  }
>  
> -while getopts "rtV" opt; do
> -	case "${opt}" in
> +while getopts "nrtV" opt; do
> +    case "${opt}" in
> +	"n") DBG="echo Would execute: " ;;
>  	"r") reap=1;;
>  	"t") fstrim=1;;
>  	"V") print_version; exitcode 0;;
> -- 
> 2.19.1
> 
