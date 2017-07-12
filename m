From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] Failure to set acl may alter group permissions
Date: Wed, 12 Jul 2017 04:47:19 -0700
Message-ID: <20170712114719.GA14398@infradead.org>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, fstests@vger.kernel.org
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 12, 2017 at 06:53:22AM -0300, Ernesto A. Fernández wrote:
> If your working directory is on a filesystem mounted with extended user
> attributes (and acl of course), this script will trigger the issue by
> filling the drive:
> 
> 
> touch test.file
> chmod go-rwx test.file
> yes xxxxxxxxxx > test.file
> i=1
> while setfattr -n user.$i test.file; do
>   ((++i))
> done
> setfacl -m m:r test.file

Can you please wire this up for xfstests?
