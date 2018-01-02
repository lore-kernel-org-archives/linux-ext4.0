From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v4 05/19] afs: convert to new i_version API
Date: Tue, 02 Jan 2018 13:57:42 -0500
Message-ID: <1514919462.3462.18.camel@kernel.org>
References: <20171222120556.7435-6-jlayton@kernel.org>
         <20171222120556.7435-1-jlayton@kernel.org>
         <5112.1514913610@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org,
        bfields@fieldses.org, neilb@suse.de, jack@suse.de,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, david@fromorbit.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com, linux-integrity@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-afs@lists.infradead.org, jaltman@auristor.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5112.1514913610@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2018-01-02 at 17:20 +0000, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > Note that AFS has quite a different definition for this counter. AFS
> > only increments it on changes to the data, not for the metadata.
> 
> This also applies to AFS directories: create, mkdir, unlink, rmdir, link,
> symlink, rename, and mountpoint creation/removal all bump the data version
> number on a directory by exactly one if they change it.
> 

Thanks! I updated that part of the the commit log to read:

    Note that AFS has quite a different definition for this counter. AFS
    only increments it on changes to the data to the data in regular files
    and contents of the directories. Inode metadata changes do not result
    in a version increment.

-- 
Jeff Layton <jlayton@kernel.org>
