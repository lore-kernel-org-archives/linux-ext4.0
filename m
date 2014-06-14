From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Fri, 13 Jun 2014 17:46:05 -0700
Message-ID: <CAKP4w2SKOkjXUfQvwfzeCuzjvpfRbLPGgmMVpo=2MSiMCDFb+w@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com> <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard> <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53165 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaFNAqZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2014 20:46:25 -0400
Received: by mail-ob0-f174.google.com with SMTP id va2so3556686obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2014 17:46:25 -0700 (PDT)
In-Reply-To: <20140613234134.GC5036@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 4:41 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> If you want to adopt this for usptream, and add support for
> BLKSECDISCARD as well as BLKDISCARD, then you could for each file that
> you want to do the per-file secure discard, you would just have to
> open the file, call the BLKSECDISCARD ioctl, and then delete the file.

That would work also. Thanks.
