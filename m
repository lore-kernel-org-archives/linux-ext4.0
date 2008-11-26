From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 23/45] CacheFiles: Be consistent about the use of mapping vs file->f_mapping in Ext3 [ver #41]
Date: Wed, 26 Nov 2008 14:40:37 +0000
Message-ID: <13588.1227710437@redhat.com>
References: <20081122173839.GJ3186@webber.adilger.int> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144338.10667.55564.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081122173839.GJ3186@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger@sun.com> wrote:

> The same patch is needed for ext4.

That doesn't look to be necessary.  Ext4 already seems to use mapping rather
than f_mapping in these places.

David
