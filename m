Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C37C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 23:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75DA0213F2
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 23:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q+X/M/cD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCRXcz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 19:32:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42098 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfCRXcz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 19:32:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2INOYov108027;
        Mon, 18 Mar 2019 23:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=BbSxiYebWuc7o9dfzWnjk2rnVYez95yKvZbUf6aqplA=;
 b=q+X/M/cDB9CCkYQgodYw0xkJFTIZc1OHXCahMMbLAOlW5ektyp0Kk9n+jUe5WUeED5Z+
 EwkAmKex0H/INtnyF5AkkXNZDxIEfMOGYH0DiICcpcn61wLU9hwohuhL+3aWrpqqrnUt
 OieU2ayig1Um9M/gPs/HaxyMW6NsE2dZ+XJLDLRYhRKPugx3JRsYjR+btyxjHGX6YU26
 YLxRCB0c7W/z6Nk4FgK3LDMTV1hei2fGL0ZvgTFOJkYqAaDh7BxUS2FgTspBBgFJtouG
 G/mS3LGAfwuCtuLhNHJm6iW07DbegcPqRDKGbTJXHwgY9xP/UdIUPDZTYl4ja8gHEog4 HQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r8rjuhjsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Mar 2019 23:32:41 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2INWddM002772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Mar 2019 23:32:40 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2INWdnm017842;
        Mon, 18 Mar 2019 23:32:39 GMT
Received: from localhost (/10.159.250.22)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Mar 2019 16:32:39 -0700
Date:   Mon, 18 Mar 2019 16:32:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: New service e2scrub_reap
Message-ID: <20190318233238.GE4936@magnolia>
References: <fb05730f-c078-ec94-72d3-83a398f936a7@molgen.mpg.de>
 <20190318214717.GB3859@mit.edu>
 <9d83dc52-dda8-6241-40ae-8a4fec4bb9eb@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d83dc52-dda8-6241-40ae-8a4fec4bb9eb@molgen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903180161
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 11:03:59PM +0100, Paul Menzel wrote:
> Dear Ted,
> 
> 
> On 18.03.19 22:47, Theodore Ts'o wrote:
> > On Mon, Mar 18, 2019 at 12:24:55PM +0100, Paul Menzel wrote:
> 
> > > On Debian Sid/unstable, I noticed the new service `scrub/e2scrub_reap.service`
> > > installed in the default target [1][2].
> > > 
> > > $ systemctl status -o short-precise e2scrub_reap.service
> > > ● e2scrub_reap.service - Remove Stale Online ext4 Metadata Check Snapshots
> > >     Loaded: loaded (/lib/systemd/system/e2scrub_reap.service; enabled; vendor preset: enabled)
> > >     Active: inactive (dead) since Mon 2019-03-18 12:17:13 CET; 1min 1s ago
> > >       Docs: man:e2scrub_all(8)
> > >    Process: 447 ExecStart=/sbin/e2scrub_all -A -r (code=exited, status=0/SUCCESS)
> > >   Main PID: 447 (code=exited, status=0/SUCCESS)
> > > 
> > > Mar 18 12:17:08.223560 plumpsklo systemd[1]: Starting Remove Stale Online ext4 Metadata Check Snapshots...
> > > Mar 18 12:17:13.996465 plumpsklo systemd[1]: e2scrub_reap.service: Succeeded.
> > > Mar 18 12:17:13.996808 plumpsklo systemd[1]: Started Remove Stale Online ext4 Metadata Check Snapshots.
> > 
> > Yeah, that's unfortunate.  I'm seeing a similar time on my (fairly
> > high-end) laptop:
> > 
> > # time e2scrub_all -A -r
> > 
> > real	0m4.356s
> > user	0m0.677s
> > sys	0m1.285s
> 
> Thank you for your response and tests.
> 
> > We should be able to fix this in general by avoiding the use of lsblk
> > at all, and in the case of e2scrub -r, just simply iterating over the
> > output of:
> > 
> > lvs --name-prefixes -o vg_name,lv_name,lv_path,origin -S lv_role=snapshot
> > 
> > (which takes about a fifth of a second on my laptop and it should be
> > even faster if there are no LVM volumes on the system)
> > 
> > And without the -r option, we should just be able to do this:
> > 
> > lvs --name-prefixes -o vg_name,lv_name,lv_path -S lv_active=active,lv_role=public
> > 
> > Right now we're calling lvs for every single block device emitted by
> > lsblk, and from what I can tell, we can do a much better job
> > optimizing e2scrub_all.
> 
> Indeed. That sounds like a way to improve the situation.

That's ... interesting.  On my developer workstations (Ubuntu 16.04 and
18.04) it generally takes 1/10th the amount of time to run
e2scrub_all.

Even on my aging ~2010 era server that only has disks it takes 0.3s:

# time e2scrub_all -A -r

real    0m0.280s
user    0m0.160s
sys     0m0.126s

I wonder what's different between our computers?  Do you have a
lvm2-lvmetad service running?

However, since e2scrub is tied to lvm, Ted is right that calling lvs in
the outer loop would be far more efficient.  I'll have a look at
reworking this.

> > > Reading the manual, the switch `-r` “removes e2scrub snapshots but do not
> > > check anything”.
> > > 
> > > Does this have to be done during boot-up, or could it be done after the
> > > default target was reached, or even during shutting down?
> > 
> > This shouldn't be blocking any other targets, I think there should be
> > a way to configure the unit file so that it runs in parallel with the
> > other systemd units.  My systemd-fu is not super strong, so I'll have
> > to do some investigating to see how we can fix this.
> 
> Sorry about my wording. It’s not about blocking targets, but an additional
> program which fights for the resources. Until the graphical target (or
> graphical login manager) is reached on my system, a lot of process already
> wait for CPU resources. That is the bottleneck during the boot-up of my
> system.
> 
> So it’d be great, if services, which actually do not have to run during
> boot-up would only be started after the default target has been reached.
> Something like the ordering dependency
> 
>     After=default.target
> 
> which does not work though to my knowledge. I’ll ask the systemd folks
> again.

The biggest risk of delaying that is that the system will crash while
the root fs was being scrubbed and then the snapshot will run out of
space while the rest of the system comes back up.  However, this service
can run in parallel with the other tasks; there's no need for it to run
solo.

--D

>
> 
> Kind regards,
> 
> Paul
