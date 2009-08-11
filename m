From: Frans Pop <elendil@planet.nl>
Subject: Re: What happened to data=guarded?
Date: Tue, 11 Aug 2009 16:54:36 +0200
Message-ID: <200908111654.38217.elendil@planet.nl>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755162AbZHKOyl@vger.kernel.org>
In-Reply-To: <20090811133721.GD29224@think>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 11 August 2009, Chris Mason wrote:
> On Tue, Aug 11, 2009 at 03:35:36PM +0200, Frans Pop wrote:
> > Somewhat unrelated, but what happened to the data=guarded patches
> > Chris Mason proposed back in April?
>
> I missed 2.6.31 but plan on sending for 2.6.32.  I promised to send
> along a forward port of the patches a while back, but I finally have
> one in testing here.  It should go out shortly.

Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
data=guarded over data=writeback. I'll certainly give it a try when it's 
available.

Thanks,
FJP
