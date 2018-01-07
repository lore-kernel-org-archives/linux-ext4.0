From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] mbcache: initialize entry->e_referenced in
 mb_cache_entry_create()
Date: Sun, 7 Jan 2018 16:23:16 -0500
Message-ID: <20180107212315.GC17380@thunk.org>
References: <20180106181038.7687-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180106181038.7687-1-ebiggers3@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 06, 2018 at 10:10:38AM -0800, Eric Biggers wrote:
> From: Alexander Potapenko <glider@google.com>
> 
> KMSAN reported use of uninitialized |entry->e_referenced| in a condition
> in mb_cache_shrink():

Thanks, applied.

					- Ted
