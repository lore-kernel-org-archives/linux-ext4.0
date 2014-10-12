From: Ivan Baldo <ibaldo@adinet.com.uy>
Subject: power loss protection
Date: Sun, 12 Oct 2014 12:07:47 -0200
Message-ID: <543A8B33.7020401@adinet.com.uy>
References: <5435661D.2040905@powercraft.nl>	<08F28BC7-34FD-46BA-9D91-CC7D57A4A4D5@dilger.ca>
	<20141011231948.GC6262@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        EXT3 Users <ext3-users@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <20141011231948.GC6262@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

     Hello.

El 11/10/14 21:19, Theodore Ts'o escribi=F3:
> If you are running some workload which is constantly calling fsync(2),
> that will be forcing journal commits, and those turn into cache flush
> commands that force all state to stable storage.  Now, if you are
> using CF cards that aren't guaranteed to have power-loss protection
> (hint: even most consumer grade SSD's do not have power loss
> protection --- you have to pay $$$ for enterprise-grade SLC SSD's to
> have power loss protection --- and I'm guessing most CF cards are so
> cheap that they won't make guarantees that all of their flash metadata
> are saved to stable store on a power loss event) the fact that you are
> constantly using fsync(2) may not be providing you with the protection
> you want after a power loss event.
>
>
     This got me worried!
     How can we test if a device really stores all the data safely after =

a barrier and sudden power loss?
     Is there a tool for that?
     I am thinking something along the lines of a tool that does writes =

with some barriers in between and then I unplug the device and run the =

same tool but in a "check mode" that tells me if the requested data =

before the barrier is really there.
     Something sysadmin friendly or maybe even user friendly, but not =

too hard to use.
     Thanks for your insight!

-- =

Ivan Baldo - ibaldo@adinet.com.uy - http://ibaldo.codigolibre.net/
 From Montevideo, Uruguay, at the south of South America.
Freelance programmer and GNU/Linux system administrator, hire me!
Alternatives: ibaldo@codigolibre.net - http://go.to/ibaldo
