From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4 encryption trap
Date: Mon, 29 Aug 2016 13:36:55 +0200
Message-ID: <20160829113655.GA16951@amd>
References: <20160829100816.GA14524@amd>
 <1846364.OxLArdGf3j@t1700bs>
 <20160829104906.GB16212@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33036 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756135AbcH2LiG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Aug 2016 07:38:06 -0400
Content-Disposition: inline
In-Reply-To: <20160829104906.GB16212@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 2016-08-29 12:49:06, Pavel Machek wrote:
> On Mon 2016-08-29 12:40:24, Bernd Schubert wrote:
> > On Monday, August 29, 2016 12:08:16 PM CEST Pavel Machek wrote:
> > > Hi!
> > > 
> > > You encrypt a directory -- sounds easy, right? Support is in 4.4
> > > kernel, my machines run newer kernels than that. Encrypting root would
> > > be hard, but encrypting parts of data partition should be easy.
> > > 
> > > Ok, lets follow howto... Need to do tune2fs. Right. Aha, still does
> > > not work, looks like I'll need to reboot.
> > > 
> > > Hmm. Will not boot. Grub no longer recognizes my /data partition, and
> > > that's where new kernels are. Old kernels are in /boot, but those are
> > > now useless. Lets copy new kernel on machine using USB stick. Does not
> > > boot. Fun.
> > > 
> > > tune2fs on root filesystem is useless, as it is too old. New one
> > > is ... on the data partition. Right. Ok, lets bring newer version of
> > > tune2fs in. "encryption" feature can not be cleared.
> > > 
> > > Argh! Come on, I did not even create single encrypted directory on the
> > > partition. I want the damn bit to go off, so I can go back to working
> > > configuration. "Old kernels can not read encrypted files" sounds ok,
> > > but "old kernels can not mount filesystem at all" is not acceptable
> > > here :-(.
> > > 
> > > Is there way to go back? Restoring 400GB from backups would not be fun
> > 
> > I have not tried it myself,  but this should work?
> > 
> > debugfs -w -R "feature -encrypt" /dev/device
> > 
> > 
> > (assuming the feature flag is called "encrypt")
> 
> Yes, I figured out debugfs could be used to do this. (But thanks for
> the command line). If all tunefs did was to set the bit, this is
> safe. Is it?
> 
> [I guess I can do fsck -fn, debugfs, fsck -fn; if it passes I should
> be safe, if it does not I can turn +encrypt back on, and would be no
> worse than I'm now. Hmm?]

Ok, done, fsck passed, I'm back to previous configuration.

I guess I was too optimistic. Using ext4 encryption would require at
least new e2fsprogs at the root filesystem, which was something I was
hoping to avoid.

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
