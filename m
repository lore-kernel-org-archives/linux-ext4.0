From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 0/2] i_version update
Date: Thu, 31 May 2007 10:01:55 +1000
Message-ID: <18014.4211.68725.44217@notabene.brown>
References: <46570DFB.3080101@bull.net>
	<20070530002100.GV85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: David Chinner <dgc@sgi.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: message from David Chinner on Wednesday May 30
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday May 30, dgc@sgi.com wrote:
> On Fri, May 25, 2007 at 06:25:31PM +0200, Jean noel Cordenner wrote:
> 
> > The aim is to fulfill a NFSv4 requirement for rfc3530:
> > "5.5.  Mandatory Attributes - Definitions
> > Name		#	DataType   Access   Description
> > ___________________________________________________________________
> > change		3	uint64       READ     A value created by the
> > 		server that the client can use to determine if file
> > 		data, directory contents or attributes of the object
>                 ^^^^
> 
> File data writes are included in this list of things that need to
> increment the version field. Hence to fulfill the crash requirement,
> that implies server data writes either need to be synchronous or
> journalled...

I think that would be excessive.

The important property if the 'change' number is:
     If the 'change' number is still the same, then the data and 
     metadata etc is still the same.

The converse of this (if the data+metadata is still then same then the
'change' is still the same) is valuable but less critical.   Having
the 'change' change when it doesn't need to will defeat client-side
caching and so will reduce performance but not correctness.

So after a crash, I think it is perfectly acceptable to assign a
change number that is known to be different to anything previously
supplied if there is any doubt about recent change history.

e.g. suppose we had a filesystem with 1-second resolution mtime, and
an in-memory 'change' counter that was incremented on every change.
When we load an inode from storage, we initialise the counter to
   -1: if the mtime is earlier than current_seconds
   current_nanoseconds:  if the mtime is equal to current_seconds.

We arrange that when the ctime changes, the change number is reset to 0.

Then when the 'change' number of an inode is required, we use the
bottom 32bits of the 'change' counter and the 32bits of the mtime.

This will provide a change number that normally changes only when the
file changes and doesn't require any extra storage on disk.
The change number will change inappropriately only when the inode has
fallen out of cache and is being reload, which is either after a crash
(hopefully rare) of when a file hasn't been used for a while, implying
that it is unlikely that any client has it in cache.

So in summary: I think it is impossible to have a change number that
changes *only* when content changes (as your 'crash' example suggests)
and it is quite achievable to have a change number that changes rarely
when the content doesn't change.

NeilBrown
