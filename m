Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B2DC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 21:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AEB22133D
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 21:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfCRVrk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 17:47:40 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45421 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfCRVrk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 17:47:40 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2ILlIZj004932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Mar 2019 17:47:18 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CBDCA420AA8; Mon, 18 Mar 2019 17:47:17 -0400 (EDT)
Date:   Mon, 18 Mar 2019 17:47:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
Subject: Re: New service e2scrub_reap
Message-ID: <20190318214717.GB3859@mit.edu>
References: <fb05730f-c078-ec94-72d3-83a398f936a7@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb05730f-c078-ec94-72d3-83a398f936a7@molgen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 12:24:55PM +0100, Paul Menzel wrote:
> Dear Ted, dear Darrick,
> 
> On Debian Sid/unstable, I noticed the new service `scrub/e2scrub_reap.service`
> installed in the default target [1][2].
> 
> $ systemctl status -o short-precise e2scrub_reap.service
> ● e2scrub_reap.service - Remove Stale Online ext4 Metadata Check Snapshots
>    Loaded: loaded (/lib/systemd/system/e2scrub_reap.service; enabled; vendor preset: enabled)
>    Active: inactive (dead) since Mon 2019-03-18 12:17:13 CET; 1min 1s ago
>      Docs: man:e2scrub_all(8)
>   Process: 447 ExecStart=/sbin/e2scrub_all -A -r (code=exited, status=0/SUCCESS)
>  Main PID: 447 (code=exited, status=0/SUCCESS)
> 
> Mar 18 12:17:08.223560 plumpsklo systemd[1]: Starting Remove Stale Online ext4 Metadata Check Snapshots...
> Mar 18 12:17:13.996465 plumpsklo systemd[1]: e2scrub_reap.service: Succeeded.
> Mar 18 12:17:13.996808 plumpsklo systemd[1]: Started Remove Stale Online ext4 Metadata Check Snapshots.

Yeah, that's unfortunate.  I'm seeing a similar time on my (fairly
high-end) laptop:

# time e2scrub_all -A -r 

real	0m4.356s
user	0m0.677s
sys	0m1.285s


We should be able to fix this in general by avoiding the use of lsblk
at all, and in the case of e2scrub -r, just simply iterating over the
output of:

lvs --name-prefixes -o vg_name,lv_name,lv_path,origin -S lv_role=snapshot

(which takes about a fifth of a second on my laptop and it should be
even faster if there are no LVM volumes on the system)

And without the -r option, we should just be able to do this:

lvs --name-prefixes -o vg_name,lv_name,lv_path -S lv_active=active,lv_role=public

Right now we're calling lvs for every single block device emitted by
lsblk, and from what I can tell, we can do a much better job
optimizing e2scrub_all.

> Reading the manual, the switch `-r` “removes e2scrub snapshots but do not
> check anything”.
> 
> Does this have to be done during boot-up, or could it be done after the
> default target was reached, or even during shutting down?

This shouldn't be blocking any other targets, I think there should be
a way to configure the unit file so that it runs in parallel with the
other systemd units.  My systemd-fu is not super strong, so I'll have
to do some investigating to see how we can fix this.

Regards,

					- Ted
