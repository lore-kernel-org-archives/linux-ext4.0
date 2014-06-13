From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Fri, 13 Jun 2014 12:44:34 -0700
Message-ID: <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com> <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard> <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org> <20140613143157.GB23180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55070 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaFMToz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2014 15:44:55 -0400
Received: by mail-oa0-f53.google.com with SMTP id l6so3387697oag.40
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2014 12:44:54 -0700 (PDT)
In-Reply-To: <20140613143157.GB23180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 7:31 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Jun 13, 2014 at 10:20:54AM -0400, Theodore Ts'o wrote:
>>
>> If you really want this to work, and be 100% secure, you really need
>> to do the secure discard at the file system layer.  The file system
>> could make sure that every single block gets a secure discard before
>> it gets reused.
>
> BTW, one major downside of doing a secure trim after every time that a
> block has been released is that it will massively increase the flash
> wear, since if you do a secure trim on a single 4k block in 512k erase
> block, assuming that secure trim has been implemented properly from a
> security perspective, it will need to copy out all of the used portion
> of the 512k erase block, and then erase it.

We did not plan on doing always-on secure-discard or always
secure-trim for those reasons.


> This is one of the reasons why I asked if you really need to worry
> about securely discarding all of the blocks on the file system, or
> just blocks containing specific really security-sensitive information
> (i.e., for Google Wallet, etc.)

Part of the "why" for this SFITRIM patch:
At some point we need to delete a bunch of files and packages and we
want to reduce the volume of recoverable data (file content, file
names, file names within databases or other files,...).
These are not security-critical files.
We understand that not all of the data can be purged, but covering
most of it would be nice.
We currently only care about ext4.
The current expected leftovers from a cleanup would be:
  - data blocks that were modified during the life-time of the files.
This includes directories containing those filenames.
  - file names in top level directories for directories that are not
getting deleted.
  - databases that are not set for deletion which referenced the files
being deleted.


> If so, you might be better off either doing per-file encryption, or
> per-file secure discard.

The per-file secure discard seems to be the way to go, as there are
only a few places in Android where this needs to be turned on.
The  current idletime-fstrim would  switch from FITRIM to SFITRIM to
reduce the leftovers.
