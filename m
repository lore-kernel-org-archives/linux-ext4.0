From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: some large dir testing results
Date: Mon, 24 Apr 2017 21:29:49 +0300
Message-ID: <7A61F035-8D10-4FE4-B4CA-1E6C87CE5AB4@gmail.com>
References: <52B4B404-9FE0-4586-A02A-3451AA5BE089@gmail.com>
 <F883702D-CECE-4FE8-ACA7-706EAB3D69FB@dilger.ca>
 <F5392F30-6F41-4CFB-A0F3-4E980EC8406C@gmail.com>
 <9166D509-BCF3-4F77-8461-1318C2B121D6@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34415 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S976113AbdDXS3z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Apr 2017 14:29:55 -0400
Received: by mail-io0-f180.google.com with SMTP id a103so199299337ioj.1
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 11:29:54 -0700 (PDT)
In-Reply-To: <9166D509-BCF3-4F77-8461-1318C2B121D6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> 21 =D0=B0=D0=BF=D1=80. 2017 =D0=B3., =D0=B2 23:58, Andreas Dilger =
<adilger@dilger.ca> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):

based on current investigation step, journal is bottleneck now.
bd2/md66-8-21787 [000] .... 439933.758608: jbd2_commit_logging: dev 9,66 =
transaction 1311 sync 0
     jbd2/md66-8-21787 [008] .... 439940.816308: jbd2_run_stats: dev =
9,66 tid 1311 wait 0 request_delay 0 running 5000 locked 0 flushing 0 =
logging 7060 handle_count 167302 blocks 170369 blocks_logged 170871

so 7s is processing, but sometimes it eats a ~100s.

41s
jbd2/md66-8-21787 [001] .... 437328.447185: jbd2_start_commit: dev 9,66 =
transaction 1197 sync 0
jbd2/md66-8-21787 [007] .... 437369.618933: jbd2_run_stats: dev 9,66 tid =
1197 wait 0 request_delay 0 running 5358 locked 5352 flushing 0 logging =
35838 handle_count 206731 blocks 206433 blocks_logged 207041
     jbd2/md66-8-21787 [007] .... 437369.618936: jbd2_end_commit: dev =
9,66 transaction 1197 sync 0 head 1192

~100s
jbd2/md66-8-21787 [000] .... 435933.607806: jbd2_run_stats: dev 9,66 tid =
1135 wait 0 request_delay 0 running 7590 locked 114 flushing 0 logging =
22 handle_count 0 blocks 0 blocks_logged 0
 jbd2/md66-8-21787 [011] .... 436030.850489: jbd2_run_stats: dev 9,66 =
tid 1136 wait 0 request_delay 0 running 5320 locked 3485 flushing 0 =
logging 88482 handle_count 123338 blocks 126810 blocks_logged 127183=
