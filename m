Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600FCC10F00
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 17:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C0B621874
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 17:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfCURaB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:30:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42740 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfCURaB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 13:30:01 -0400
Received: by mail-io1-f70.google.com with SMTP id i1so5723941ioq.9
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2019 10:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fLQGdQSSgHknyy/V+VRgiv7MKw96VhP0gMOndDdmz54=;
        b=fvs9h+H9HRNJy5sxrCnd+fZEWfOeU8cBJgkkYZNn6pfNYFSRjUaC90DNfRAlqew3SV
         +0d/1BJt6XFPhsGo0L/Dq0MH8pQ3mNcnuKIVe9HREMZypPjfNIdpl4qiQ6iSnMdl3K9Z
         Uy6ouXLGWNCCZHQFqgMPblx+XRmaKL5RDudcrPHpmVDYx81nzMWyNHzm35q9LnOhQSD7
         UKMxwqh+eeaa4USrMlHribzX6Sv34hdqHGcRbKWZANt/TL+5OOnhuWJSDFm7mOxWf6ux
         f8RIk0dtqGLG7t4YyOVnFMpk1qKiM0ONqD3kvJSvOVU+JhilMLyZfdwyv8lg2hakdoMH
         H3Ng==
X-Gm-Message-State: APjAAAUoXoxot7KJwHxqYMWGnFCFoNPYz9N676VjaQ5ljjwZ3pc+/3sF
        c94eEa1G6BWzh9iKb2ArSYEe7WQQR0sgxOGua4xr2YvXCvyE
X-Google-Smtp-Source: APXvYqzypj0cLkZAe6ywra+tvAN6+dxA3Nmkam8kTumR99hdy+/cb70Mef6MK220NE7gIEXRtPP046FqMRCL6SISXTyrEiM2xBLn
MIME-Version: 1.0
X-Received: by 2002:a6b:8d87:: with SMTP id p129mr3674003iod.10.1553189400392;
 Thu, 21 Mar 2019 10:30:00 -0700 (PDT)
Date:   Thu, 21 Mar 2019 10:30:00 -0700
In-Reply-To: <0000000000009a01370582c6772a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007ab8ab05849e1647@google.com>
Subject: Re: INFO: rcu detected stall in ext4_file_write_iter
From:   syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>
To:     acme@kernel.org, adilger.kernel@dilger.ca, dvyukov@google.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b1becf200000
start commit:   [unknown
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1471becf200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1071becf200000
dashboard link: https://syzkaller.appspot.com/bug?extid=7d19c5fe6a3f1161abb7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103908f8c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105e5cd0c00000

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
