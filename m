From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: Ext4 projects for 2014
Date: Thu, 12 Dec 2013 10:08:49 +0400
Message-ID: <1386828529.3972.6.camel@slavad-ubuntu>
References: <20131209014330.GA9195@thunk.org>
	 <20131212050002.GH31386@dastard>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alt-proxy11.mail.unifiedlayer.com ([74.220.211.241]:59524 "HELO
	alt-proxy11.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751270Ab3LLGPj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 01:15:39 -0500
In-Reply-To: <20131212050002.GH31386@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2013-12-12 at 16:00 +1100, Dave Chinner wrote:
> On Sun, Dec 08, 2013 at 08:43:30PM -0500, Theodore Ts'o wrote:
> > Unfortunately, I forgot my notes from our last conference call before
> > heading off to the airport.  My fault for taking the notes on paper
> > instead of electronically in the first place.  :-(
> > 
> > This is my best reconstruction of some of the ext4 projects for 2014.
> > Please let me know if I've forgotten anything.
> > 
> > 1)  Support for Shingled (SMR) Drives
> 
> Do you have any specific plans on how you are going to support these
> drives? I'm curious, because the differences affect all fielsystems
> so maybe there's some common solutions there...
> 

Yes, it's really interesting question. Because I know about trying to
use Log-structured File System or likewise approaches for the case of
Shingled (SMR) drives. But ext4 is another case. :)

So, what preliminary vision of such support in ext4?

Thanks,
Vyacheslav Dubeyko.


