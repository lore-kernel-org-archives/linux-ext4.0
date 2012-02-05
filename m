From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 5 Feb 2012 18:23:02 +0100
Message-ID: <20120205172302.GA7057@citd.de>
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
	<4F2EB017.5090006@redhat.com>
	<9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Ron Yorston <rmy@tigress.co.uk>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On 05.02.2012 09:55, Andreas Dilger wrote:

> > Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
> 
> I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked, then the file would already be sparse, so I don't think that will help in this case...

With that argumentation you wouldn't need the tool in the first place.

"How can a bunch of zeros be in a file in the first place?"
"Can only be because of the deficiency of another program."

And who is to say that you wouldn't want to repeat such a thing from 
time to time, without SEEK_HOLE/SEEK_DATE you MAY crunch through big 
regions of zeros for no gain at all.



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
