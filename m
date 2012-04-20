From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Fri, 20 Apr 2012 12:38:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1204201236230.27750@dhcp-27-109.brq.redhat.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu> <4F913776.5080603@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F913776.5080603@itwm.fraunhofer.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 20 Apr 2012, Bernd Schubert wrote:

> On 04/19/2012 09:20 PM, Theodore Ts'o wrote:
> > As I had brought up during one of the lightning talks at the Linux
> > Storage and Filesystem workshop, I am interested in introducing two new
> > open flags, O_HOT and O_COLD.  These flags are passed down to the
> > individual file system's inode operations' create function, and the file
> > system can use these flags as a hint regarding whether the file is
> > likely to be accessed frequently or not.
> > 
> > In the future I plan to do further work on how ext4 would use these
> > flags, but I want to first get the ability to pass these flags plumbed
> > into the VFS layer and the code points for O_HOT and O_COLD reserved.
> > 
> 
> Ted, you still remember the directory-block read-ahead patches I sent last
> year for ext4 and which you declined, as it would add another mount parameter
> for ext4?
> 
> http://www.digipedia.pl/usenet/thread/11916/24502/#post24502
> 
> 
> If an application could use those flags to the file system (and then not only
> ext4, but any file system) to indicate a certain directory is important and
> frequently accessed, it would be simple to update those patches to work
> without another mount option.
> And while I updating our FhGFS meta data on disk layout to workaround the
> general problem we, we (and for example Lustre) are still affected the
> object-storage-side.
> 
> 
> Thanks,
> Bernd

Nice, there are probably lots of flags we can think of, so we
definitely need good interface for it as we certainly do not want to use
O_HOT open flags here :)

Thanks!
-Lukas
