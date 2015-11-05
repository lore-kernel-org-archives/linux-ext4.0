From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Ext4: Fix extended timestamp encoding and decoding
Date: Thu, 05 Nov 2015 19:25:55 +0000
Message-ID: <27717.1446751555@warthog.procyon.org.uk>
References: <20151105181424.GD2213@birch.djwong.org> <20151105144916.6333.58880.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, tytso@mit.edu, kalpak@clusterfs.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, arnd@arndb.de
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151105181424.GD2213@birch.djwong.org>
Content-ID: <27716.1446751555.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> There's been a patch to fix this for a very long time:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/40978

So I see, though that patch doesn't also fix the encode case.

David
