From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Initialize list properly
Date: Thu, 12 Feb 2009 17:00:37 -0500
Message-ID: <20090212220037.GG6922@mini-me.lan>
References: <a4423d670902100906q36e7f36fo53ba2060f5644303@mail.gmail.com> <1234422331-32766-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-next@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1234422331-32766-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 12, 2009 at 12:35:31PM +0530, Aneesh Kumar K.V wrote:
> We need to initialize the list_head properly before we add
> them to the any list. Otherwise with list debug on we get
> list corruption warnings.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Added to the ext4 patch queue with a slight adjustment in the patch
commit for readability issues:

   When creating a new ext4_prealloc_space structure, we have to
   initialize its list_head pointers before we add them to any prealloc
   lists.  Otherwise, with list debug enabled, we will get list
   corruption warnings.

   Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
   Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
