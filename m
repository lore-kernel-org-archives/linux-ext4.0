From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
Date: Thu, 26 Jun 2014 18:30:22 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406261829190.2172@localhost.localdomain>
References: <1403192228-25771-1-git-send-email-lczerner@redhat.com> <20140626162450.GD6826@thunk.org> <alpine.LFD.2.00.1406261827080.2172@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1047548038-1403800225=:2172"
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1406261827080.2172@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1047548038-1403800225=:2172
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 26 Jun 2014, Luká¨ Czerner wrote:

> Date: Thu, 26 Jun 2014 18:28:57 +0200 (CEST)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
> Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
> 
> On Thu, 26 Jun 2014, Theodore Ts'o wrote:
> 
> > Date: Thu, 26 Jun 2014 12:24:50 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
> > Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
> > 
> > I like the performance improvement of your patch, but I'm concerned
> > that it might be a bit too complicated to push outside of the merge
> > window.
> > 
> > So what I propose doing is this.  We'll take Jan's patches and after
> > testing, we'll push it to Linus.  Then for the the 3.17 merge window,
> > after we've had more opportunity for testing and for other folks to
> > review your changes, we can queue this patch (or its successor).
> > 
> > Does that seem like a good path forward?
> > 
> > 						- Ted
> 
> It does. But this is not exactly a critical bug and it has been
> there since the introduction of punch hole for indirect file. But I
> guess it's better to fix it sooner rather than later, so I am fine
> with this.

It's also better to send Jan's fix to stable trees and let my fix be
just in the Linus tree since it's quite big for stable I think.

-Lukas

> 
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1047548038-1403800225=:2172--
