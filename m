From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Date: Fri, 21 Aug 2009 15:39:08 +0300
Message-ID: <84144f020908210539h32ef9db1lda81d1a646efecea@mail.gmail.com>
References: <20090820015624.GE524@hash.localnet>
	 <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
	 <20090820111937.GF524@hash.localnet>
	 <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
	 <20090821020633.GA25571@hash.localnet>
	 <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bob Copeland <me@bobcopeland.com>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755556AbZHUMjL@vger.kernel.org>
In-Reply-To: <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 21, 2009 at 9:46 AM, Vegard Nossum<vegard.nossum@gmail.com> wrote:
> I think that's it. Any thoughts? I put Eric Paris on Cc.

Nice catch by kmemcheck! I don't think that explains the original slab
corruption, though. Bob, you might want to try again with the fsnotify
fix applied.

                        Pekka
