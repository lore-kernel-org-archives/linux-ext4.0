From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH -v2] mke2fs: fix hugefile creation so the hugefile(s) are contiguous
Date: Fri, 23 Jun 2017 10:56:14 -0700
Message-ID: <CAAeU0aN28UApZvSckP8s63xOgg66m3JM5bGtgjnYv7cyjN7tfg@mail.gmail.com>
References: <20170623000009.27984-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:36569 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbdFWR4Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2017 13:56:16 -0400
Received: by mail-yb0-f171.google.com with SMTP id s9so15311582ybe.3
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jun 2017 10:56:15 -0700 (PDT)
In-Reply-To: <20170623000009.27984-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +                       if (logical_end + 1 - logical_start != len) {
> +                         print logical_end + 1 - logical_start, len;
> +                               print "UNEXPECTED LENGTH for extent", $0;
Can you fix indentation of first print above?

> +                       }
> +                       if (physical_end + 1 - physical_start != len) {
> +                         print physical_end + 1 - physical_start, len;
> +                               print "UNEXPECTED LENGTH for extent", $0;
Same here.
