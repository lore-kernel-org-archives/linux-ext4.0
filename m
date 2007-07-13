From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Fri, 13 Jul 2007 15:22:29 +0300
Message-ID: <84144f020707130522l3a800b61i6b7c4d9084277cdf@mail.gmail.com>
References: <1183275498.4010.135.camel@localhost.localdomain>
	 <20070710224011.e60b9864.akpm@linux-foundation.org>
	 <1184322648.4315.2.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Kalpak Shah" <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:54686 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbXGMMWa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 08:22:30 -0400
Received: by wa-out-1112.google.com with SMTP id v27so553351wah
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2007 05:22:30 -0700 (PDT)
In-Reply-To: <1184322648.4315.2.camel@garfield.linsyssoft.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 7/13/07, Kalpak Shah <kalpak@clusterfs.com> wrote:
> > EXT4_DIR_LINK_MAX() is buggy: it evaluates its arg twice.
>
> #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)

[snip]

> Sorry, I didn't understand what is the problem with this macro?

The expression represented by 'dir' is evaluated twice (think dir++
here). It's safer to make it a static inline function.

                                       Pekka
